require 'rails_helper'

RSpec.describe Clients::Process, type: :service do
  let(:data) do
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

  context 'without a client' do
    subject(:service) { described_class.call(data) }

    it 'creates a client' do
      expect { service }
        .to change(Client, :count).from(0).to(1)
        .and change(Address, :count).from(0).to(1)

      client = Client.first

      expect(client).to have_attributes(
        'first_name' => 'Jerry',
        'last_name' => 'Seinfeld',
        'date_of_birth' => Date.new(1954, 0o4, 29),
        'email' => 'email@example.com',
        'private_note' => 'Yada yada yada'
      )

      expect(client.address).to have_attributes(
        'address_line_1' => '129 W 81st St',
        'address_line_2' => 'Appartment 5A',
        'suburb' => 'New York',
        'state' => 'NY',
        'post_code' => '10024',
        'country' => 'USA'
      )
    end

    it 'returns errors' do
      data[:first_name] = nil
      data[:state] = nil

      expect { service }
        .to not_change(Client, :count)
        .and not_change(Address, :count)

      expect(service.errors.full_messages).to contain_exactly(
        "First name can't be blank",
        "State can't be blank"
      )
    end
  end

  context 'with a client' do
    subject(:service) { described_class.call(data, client: client) }

    let!(:client) { create :client }

    it 'updates the client' do
      expect { service }
        .to change { client.reload.updated_at }
        .and change(client.reload, :versions)
        .and change { client.address.reload.versions }

      expect(client.reload).to have_attributes(
        'first_name' => 'Jerry',
        'last_name' => 'Seinfeld',
        'date_of_birth' => Date.new(1954, 0o4, 29),
        'email' => 'email@example.com',
        'private_note' => 'Yada yada yada'
      )

      expect(client.address.reload).to have_attributes(
        'address_line_1' => '129 W 81st St',
        'address_line_2' => 'Appartment 5A',
        'suburb' => 'New York',
        'state' => 'NY',
        'post_code' => '10024',
        'country' => 'USA'
      )
    end

    it 'returns errors' do
      data[:first_name] = nil
      data[:state] = nil

      expect { service }
        .to not_change(client.reload, :updated_at)
        .and not_change(client.address.reload, :updated_at)

      expect(service.errors.full_messages).to contain_exactly(
        "First name can't be blank",
        "State can't be blank"
      )
    end
  end
end
