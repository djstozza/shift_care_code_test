class Auth::ProcessToken < ApplicationService
  attr_reader :request, :current_admin_id

  validate :valid_token

  def initialize(request)
    @request = request
  end

  def call
    valid?
  end

  private

  def valid_token
    return if request.headers['Authorization'].blank?

    begin
      @current_admin_id = jwt_payload['id']
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      errors.add(:base, 'Your session has expired')
    end
  end

  def jwt_payload
    JWT.decode(
      request.headers['Authorization'].split(' ')[1],
      Rails.application.secrets.secret_key_base,
    ).first
  end
end
