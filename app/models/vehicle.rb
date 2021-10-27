# == Schema Information
#
# Table name: vehicles
#
#  id           :bigint           not null, primary key
#  make         :citext           not null
#  model        :citext           not null
#  number_plate :citext           not null
#  other_make   :citext
#  year         :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  plumber_id   :bigint
#
# Indexes
#
#  index_vehicles_on_number_plate  (number_plate) UNIQUE
#  index_vehicles_on_plumber_id    (plumber_id)
#

class Vehicle < ApplicationRecord
  MINIMUM_YEAR = 2000
  belongs_to :plumber

  validates :make, :model, :number_plate, :year, presence: true
  validates :number_plate, uniqueness: true
  validates :year,
            allow_blank: true,
            numericality: {
              greater_than_or_equal_to: MINIMUM_YEAR,
              less_than_or_equal_to: Date.current.year,
            }
  validate :other_make_presence

  enum make: {
    toyota: 'Toyota',
    ford: 'Ford',
    holden: 'Holden',
    nissan: 'Nissan',
    suzuki: 'Suzuki',
    isuzu: 'Isuzu',
    other: 'Other',
  }

  private

  def other_make_presence
    return if other? && other_make.present?
    return errors.add(:other_make, 'cannot be blank') if other? && other_make.blank?
    return errors.add(:other_make, 'should not be present') if other_make.present? && !other?
  end
end
