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

class ClientSerializer < BaseSerializer
  ATTRS = %w[
    id
    email
    first_name
    last_name
    date_of_birth
  ].freeze

  def serializable_hash(*)
    attributes.slice(*ATTRS).tap do |attrs|
      attrs[:private_note] = private_note if includes[:private_note]
      attrs[:address] = serialized_address if includes[:address]
    end
  end

  private

  def serialized_address
    AddressSerializer.new(address)
  end
end
