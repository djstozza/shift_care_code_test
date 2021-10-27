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

class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  validates :address_line_1, :suburb, :state, :post_code, :country, presence: true
end
