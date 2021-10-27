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

FactoryBot.define do
  factory :vehicle do
    make { 'toyota' }
    model { 'Hilux' }
    sequence :number_plate do |n|
      n
    end
    year { 2020 }

    association :plumber
  end
end
