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

require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  subject(:vehicle) { create :vehicle }

  it { is_expected.to validate_presence_of(:make) }
  it { is_expected.to validate_presence_of(:model) }
  it { is_expected.to validate_presence_of(:year) }

  it 'validates the numericality of the year' do
    expect(subject).to validate_numericality_of(:year)
      .is_greater_than_or_equal_to(described_class::MINIMUM_YEAR)
      .is_less_than_or_equal_to(Date.current.year)
  end

  it 'validates the presence of other_make if the make is other' do
    invalid = build(:vehicle, make: 'other')

    expect(invalid).not_to be_valid
  end
end
