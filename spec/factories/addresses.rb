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

FactoryBot.define do
  factory :address do
    address_line_1 { '308 Negra Arroyo Lane' }
    suburb { 'Albuquerque' }
    post_code { '87104' }
    state { 'NM' }
    country { 'USA' }

    association :addressable, factory: :client

    trait :plumber_address do
      association :addressable, factory: :plumber
    end
  end
end
