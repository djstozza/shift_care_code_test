class AdminSerializer < BaseSerializer
  ATTRS = %w[
    id
    email
    first_name
    last_name
  ].freeze

  def serializable_hash(*)
    attributes.slice(*ATTRS)
  end
end
