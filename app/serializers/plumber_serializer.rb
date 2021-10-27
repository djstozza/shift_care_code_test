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

class PlumberSerializer < BaseSerializer
  ATTRS = %w[
    id
    email
    first_name
    last_name
  ].freeze

  def serializable_hash(*)
    attributes.slice(*ATTRS).tap do |attrs|
      attrs[:address] = serialized_address if includes[:address]
    end
  end

  private

  def serialized_address
    AddressSerializer.new(address)
  end
end
