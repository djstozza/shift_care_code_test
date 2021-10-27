# == Schema Information
#
# Table name: admins
#
#  id                     :bigint           not null, primary key
#  current_sign_in_at     :datetime
#  email                  :citext           not null
#  encrypted_password     :string           not null
#  first_name             :citext           not null
#  last_name              :citext           not null
#  last_sign_in_at        :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#

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
