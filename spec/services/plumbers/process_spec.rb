require 'rails_helper'

RSpec.describe Plumbers::Process, type: :service do
  let(:data) do
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

  context 'without a plumber' do
    subject(:service) { described_class.call(data) }

    it 'creates a plumber' do
      expect { service }
        .to change(Plumber, :count).from(0).to(1)
        .and change(Address, :count).from(0).to(1)

      plumber = Plumber.first

      expect(plumber).to have_attributes(
        'first_name' => 'Tony',
        'last_name' => 'Soprano',
        'email' => 'email@example.com'
      )

      expect(plumber.address).to have_attributes(
        'address_line_1' => '14 Aspen Dr',
        'suburb' => 'Caldwell',
        'state' => 'NJ',
        'post_code' => '07006',
        'country' => 'USA'
      )
    end

    it 'returns errors' do
      data[:first_name] = nil
      data[:state] = nil

      expect { service }
        .to not_change(Plumber, :count)
        .and not_change(Address, :count)

      expect(service.errors.full_messages).to contain_exactly(
        "First name can't be blank",
        "State can't be blank"
      )
    end
  end

  context 'with a plumber' do
    subject(:service) { described_class.call(data, plumber: plumber) }

    let!(:plumber) { create :plumber }

    it 'updates the plumber' do
      expect { service }
        .to change { plumber.reload.updated_at }
        .and change(plumber.reload, :versions)
        .and change { plumber.address.reload.versions }

      expect(plumber.reload).to have_attributes(
        'first_name' => 'Tony',
        'last_name' => 'Soprano',
        'email' => 'email@example.com'
      )

      expect(plumber.address.reload).to have_attributes(
        'address_line_1' => '14 Aspen Dr',
        'suburb' => 'Caldwell',
        'state' => 'NJ',
        'post_code' => '07006',
        'country' => 'USA'
      )
    end

    it 'returns errors' do
      data[:first_name] = nil
      data[:state] = nil

      expect { service }
        .to not_change(plumber.reload, :updated_at)
        .and not_change(plumber.address.reload, :updated_at)

      expect(service.errors.full_messages).to contain_exactly(
        "First name can't be blank",
        "State can't be blank"
      )
    end
  end
end
