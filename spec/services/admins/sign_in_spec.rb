require 'rails_helper'

RSpec.describe Admins::SignIn, type: :service do
  let!(:admin) { create :admin }

  it 'generates the jwt token on call' do
    data = {
      email: admin.email,
      password: admin.password,
    }

    service = described_class.new(data, admin: admin)

    token = service.call

    decoded_jwt = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]

    expect(decoded_jwt).to include(
      'id' => service.admin.id,
      'exp' => be_within(1.second).of(2.hours.from_now.to_i)
    )
  end

  it 'fails if the password is invalid' do
    data = {
      email: admin.email,
      password: 'invalid',
    }

    service = described_class.new(data, admin: admin)

    service.call

    expect(service.errors).to contain_exactly(
      'Email or password is invalid'
    )
  end

  it 'fails if the email is invalid' do
    service = described_class.new(
      email: 'some@admin.com',
      password: admin.password,
    )

    service.call

    expect(service.errors).to contain_exactly(
      'Email or password is invalid'
    )
  end
end
