require 'rails_helper'

RSpec.describe 'api/clients', type: :request do
  include ApplicationHelper
  let!(:admin) { create :admin }

  let(:client_params) do
    {
      first_name: 'Jerry',
      last_name: 'Seinfeld',
      date_of_birth: '29/04/1954',
      email: 'email@example.com',
      private_note: 'Yada yada yada',
      address_line_1: '129 W 81st St',
      address_line_2: 'Appartment 5A',
      suburb: 'New York',
      state: 'NY',
      post_code: '10024',
      country: 'USA',
    }
  end

  let(:client) { create :client }

  before { api.authenticate(admin) }

  describe 'GET - Index' do
    let!(:client_1) { create :client }
    let!(:client_2) { create :client }

    it 'returns a list of clients' do
      api.get api_clients_path, params: { format: 'json' }

      expect(api.response).to have_http_status(:success)

      expect(api.data).to eq(
        [
          {
            'id' => client_1.to_param,
            'first_name' => client_1.first_name,
            'last_name' => client_1.last_name,
            'date_of_birth' => client_1.date_of_birth.strftime('%Y-%m-%d'),
            'email' => client_1.email,
          },
          {
            'id' => client_2.to_param,
            'first_name' => client_2.first_name,
            'last_name' => client_2.last_name,
            'date_of_birth' => client_2.date_of_birth.strftime('%Y-%m-%d'),
            'email' => client_2.email,
          },
        ]
      )
    end
  end

  describe 'POST' do
    it 'creates a client' do
      expect do
        api.post api_clients_path, params: { client: client_params, format: 'json' }
      end.to change(Client, :count).from(0).to(1)

      expect(api.response).to have_http_status(:success)

      client = Client.first

      expect(api.data).to match(
        'id' => client.to_param,
        'first_name' => 'Jerry',
        'last_name' => 'Seinfeld',
        'date_of_birth' => '1954-04-29',
        'email' => 'email@example.com',
        'private_note' => 'Yada yada yada',
        'address' => {
          'id' => client.address.to_param,
          'address_line_1' => '129 W 81st St',
          'address_line_2' => 'Appartment 5A',
          'suburb' => 'New York',
          'state' => 'NY',
          'post_code' => '10024',
          'country' => 'USA',
        }
      )
    end

    it 'fails if the params are invalid' do
      invalid_params = {
        **client_params,
        first_name: nil,
      }

      api.post api_clients_path, params: { client: invalid_params, format: 'json' }

      expect(api.response).to have_http_status(:unprocessable_entity)

      expect(api.errors).to contain_exactly(
        a_hash_including('detail' => "First name can't be blank", 'source' => 'first_name'),
      )
    end

    it 'sets a new version with the admin as the initiator' do
      api.post api_clients_path, params: { client: client_params, format: 'json' }

      client = Client.first

      expect(client.versions.last.whodunnit).to eq(name(admin))
    end
  end

  describe 'PUT' do
    it 'updates the client' do
      api.put api_client_path(client), params: { client: client_params, format: 'json' }

      expect(api.response).to have_http_status(:success)

      expect(api.data).to match(
        'id' => client.to_param,
        'first_name' => 'Jerry',
        'last_name' => 'Seinfeld',
        'date_of_birth' => '1954-04-29',
        'email' => 'email@example.com',
        'private_note' => 'Yada yada yada',
        'address' => {
          'id' => client.reload.address.to_param,
          'address_line_1' => '129 W 81st St',
          'address_line_2' => 'Appartment 5A',
          'suburb' => 'New York',
          'state' => 'NY',
          'post_code' => '10024',
          'country' => 'USA',
        }
      )
    end

    it 'sets a new version with the admin as the initiator' do
      api.put api_client_path(client), params: { client: client_params, format: 'json' }

      expect(client.versions.last.whodunnit).to eq(name(admin))
    end

    it 'fails if the params are invalid' do
      invalid_params = {
        **client_params,
        first_name: nil,
      }

      api.put api_client_path(client), params: { client: invalid_params, format: 'json' }

      expect(api.response).to have_http_status(:unprocessable_entity)

      expect(api.errors).to contain_exactly(
        a_hash_including('detail' => "First name can't be blank", 'source' => 'first_name'),
      )
    end
  end
end
