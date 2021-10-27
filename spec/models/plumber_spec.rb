# == Schema Information
#
# Table name: plumbers
#
#  id         :bigint           not null, primary key
#  email      :citext           not null
#  first_name :citext           not null
#  last_name  :citext           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_plumbers_on_email  (email) UNIQUE
#

require 'rails_helper'

RSpec.describe Plumber, type: :model do
  subject(:plumber) { create :plumber }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value(plumber.email).for(:email) }
  it { is_expected.not_to allow_value('invalid').for(:email) }
end
