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

class Admin < ApplicationRecord
  # NIST recommended length - https://auth0.com/blog/dont-pass-on-the-new-nist-password-guidelines/
  MIN_PASSWORD_LENGTH = ENV['MIN_PASSWORD_LENGTH'] || 8
  # SecurePassword enforces max password length to prevent DoS via bcrypt hashing
  MAX_PASSWORD_LENGTH = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         password_length: MIN_PASSWORD_LENGTH..MAX_PASSWORD_LENGTH

  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness: true, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
