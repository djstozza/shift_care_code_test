# == Schema Information
#
# Table name: addresses
#
#  id               :bigint           not null, primary key
#  address_line_1   :citext
#  address_line_2   :citext
#  addressable_type :string
#  country          :citext
#  post_code        :citext
#  state            :citext
#  suburb           :citext
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  addressable_id   :bigint
#
# Indexes
#
#  index_addresses_on_addressable_type_and_addressable_id  (addressable_type,addressable_id)
#

require 'rails_helper'

RSpec.describe Address, type: :model do
  subject(:address) { create :address }

  it { is_expected.to validate_presence_of(:address_line_1) }
  it { is_expected.to validate_presence_of(:suburb) }
  it { is_expected.to validate_presence_of(:country) }
  it { is_expected.to validate_presence_of(:post_code) }

  it 'sets the addressable type' do
    expect(address.addressable_type).to eq('Client')

    plumber_address = create :address, :plumber_address
    expect(plumber_address.addressable_type).to eq('Plumber')
  end
end
