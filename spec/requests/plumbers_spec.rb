require 'rails_helper'

RSpec.describe 'api/plumbers', type: :request do
  include ApplicationHelper
  let!(:admin) { create :admin }

  let(:plumber_params) do
    {
      first_name: 'Tony',
      last_name: 'Soprano',
      email: 'email@example.com',
      address_line_1: '14 Aspen Dr',
      suburb: 'Caldwell',
      state: 'NJ',
      post_code: '07006',
      country: 'USA',
    }
  end

  let(:plumber) { create :plumber }

  before { api.authenticate(admin) }

  describe 'GET - Index' do
    let!(:plumber_1) { create :plumber }
    let!(:plumber_2) { create :plumber }

    it 'returns a list of plumbers' do
      api.get api_plumbers_path, params: { format: 'json' }

      expect(api.response).to have_http_status(:success)

      expect(api.data).to eq(
        [
          {
            'id' => plumber_1.to_param,
            'first_name' => plumber_1.first_name,
            'last_name' => plumber_1.last_name,
            'email' => plumber_1.email,
          },
          {
            'id' => plumber_2.to_param,
            'first_name' => plumber_2.first_name,
            'last_name' => plumber_2.last_name,
            'email' => plumber_2.email,
          },
        ]
      )
    end
  end

  describe 'POST' do
    it 'creates a plumber' do
      expect do
        api.post api_plumbers_path, params: { plumber: plumber_params, format: 'json' }
      end.to change(Plumber, :count).from(0).to(1)

      expect(api.response).to have_http_status(:success)

      plumber = Plumber.first

      expect(api.data).to match(
        'id' => plumber.to_param,
        'first_name' => 'Tony',
        'last_name' => 'Soprano',
        'email' => 'email@example.com',
        'address' => {
          'id' => plumber.address.to_param,
          'address_line_1' => '14 Aspen Dr',
          'address_line_2' => nil,
          'suburb' => 'Caldwell',
          'state' => 'NJ',
          'post_code' => '07006',
          'country' => 'USA',
        }
      )
    end

    it 'fails if the params are invalid' do
      invalid_params = {
        **plumber_params,
        first_name: nil,
      }

      api.post api_plumbers_path, params: { plumber: invalid_params, format: 'json' }

      expect(api.response).to have_http_status(:unprocessable_entity)

      expect(api.errors).to contain_exactly(
        a_hash_including('detail' => "First name can't be blank", 'source' => 'first_name'),
      )
    end

    it 'sets a new version with the admin as the initiator' do
      api.post api_plumbers_path, params: { plumber: plumber_params, format: 'json' }

      plumber = Plumber.first

      expect(plumber.versions.last.whodunnit).to eq(name(admin))
    end
  end

  describe 'PUT' do
    it 'updates the plumber' do
      api.put api_plumber_path(plumber), params: { plumber: plumber_params, format: 'json' }

      expect(api.response).to have_http_status(:success)

      expect(api.data).to match(
        'id' => plumber.to_param,
        'first_name' => 'Tony',
        'last_name' => 'Soprano',
        'email' => 'email@example.com',
        'address' => {
          'id' => plumber.reload.address.to_param,
          'address_line_1' => '14 Aspen Dr',
          'address_line_2' => nil,
          'suburb' => 'Caldwell',
          'state' => 'NJ',
          'post_code' => '07006',
          'country' => 'USA',
        }
      )
    end

    it 'sets a new version with the admin as the initiator' do
      api.put api_plumber_path(plumber), params: { plumber: plumber_params, format: 'json' }

      expect(plumber.versions.last.whodunnit).to eq(name(admin))
    end

    it 'fails if the params are invalid' do
      invalid_params = {
        **plumber_params,
        first_name: nil,
      }

      api.put api_plumber_path(plumber), params: { plumber: invalid_params, format: 'json' }

      expect(api.response).to have_http_status(:unprocessable_entity)

      expect(api.errors).to contain_exactly(
        a_hash_including('detail' => "First name can't be blank", 'source' => 'first_name'),
      )
    end
  end
end
