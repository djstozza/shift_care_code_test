# == Schema Information
#
# Table name: clients
#
#  id            :bigint           not null, primary key
#  date_of_birth :date             not null
#  email         :citext           not null
#  first_name    :citext           not null
#  last_name     :citext           not null
#  private_note  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_clients_on_email  (email) UNIQUE
#

require 'rails_helper'

RSpec.describe Client, type: :model do
  include ActiveSupport::Testing::TimeHelpers
  subject(:client) { create :client, date_of_birth: '1988-10-28' }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:date_of_birth) }
  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value(client.email).for(:email) }
  it { is_expected.not_to allow_value('invalid').for(:email) }

  describe '#age' do
    it 'calculates the age of the client' do
      travel_to Time.zone.local(2021, 10, 27) do
        expect(client.age).to eq(32)
      end
    end
  end
end
