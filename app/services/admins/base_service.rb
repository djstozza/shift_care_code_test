class Admins::BaseService < ApplicationService
  attr_reader :admin, :email, :password, :token

  def initialize(data, admin: nil)
    @admin = admin
    @email = data[:email]
    @password = data[:password]
    @token = nil
  end

  def call
    return unless valid?

    generate_jwt
  end

  private

  def password_is_correct
    return if admin&.valid_password?(password)

    errors.add('email or password', 'is invalid')
  end

  def generate_jwt
    @token = JWT.encode(
      {
        id: admin.id,
        exp: (ENV['SESSION_EXPIRY'].to_i || 120).minutes.from_now.to_i,
      },
      Rails.application.secrets.secret_key_base,
    )
  end
end
