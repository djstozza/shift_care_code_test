require 'rails_helper'

RSpec.describe 'api/sessions', type: :request do
  include ActiveSupport::Testing::TimeHelpers
  let!(:admin) { create :admin }

  describe 'GET' do
    it 'returns the admin token' do
      api.post api_sessions_path, params: { admin: { email: admin.email, password: admin.password }, format: 'json' }

      decoded_jwt = JWT.decode(api.data['token'], Rails.application.secrets.secret_key_base)[0]

      expect(decoded_jwt).to include(
        'id' => admin.id,
        'exp' => be_within(1.second).of(ENV['SESSION_EXPIRY'].to_i.minutes.from_now.to_i)
      )

      expect(api.data).to include(
        'admin' => a_hash_including(
          'id' => admin.to_param,
          'email' => admin.email,
        )
      )
    end

    it 'fails if invalid attributes are passed' do
      api.post api_sessions_path,
               params: { admin: { email: admin.email, password: 'invalid' }, format: 'json' }

      expect(api.response).to have_http_status(:unprocessable_entity)
      expect(api.errors).to contain_exactly(
        a_hash_including('detail' => 'Email or password is invalid'),
      )

      api.post api_sessions_path,
               params: { admin: { email: 'invalid@email.com', password: admin.password }, format: 'json' }

      expect(api.response).to have_http_status(:unprocessable_entity)
      expect(api.errors).to contain_exactly(
        a_hash_including('detail' => 'Email or password is invalid'),
      )
    end
  end

  describe 'PUT' do
    before { api.authenticate(admin) }

    it 'responds with an updated token' do
      travel_to ENV['SESSION_EXPIRY'].to_i.minutes.from_now - 1.minute do
        api.put api_sessions_path, params: { format: 'json' }

        decoded_jwt = JWT.decode(api.data['token'], Rails.application.secrets.secret_key_base)[0]

        expect(decoded_jwt).to include(
          'id' => admin.id,
          'exp' => ENV['SESSION_EXPIRY'].to_i.minutes.from_now.to_i
        )
      end
    end

    it 'fails if the token has expired' do
      travel_to ENV['SESSION_EXPIRY'].to_i.minutes.from_now + 1.minute do
        api.put api_sessions_path, params: { format: 'json' }

        expect(api.response).to have_http_status(:unauthorized)
      end
    end
  end
end
