require 'rails_helper'

RSpec.describe Jobs::Process, type: :service do
  let!(:client) { create :client }
  let!(:plumber_1) { create :plumber }
  let!(:plumber_2) { create :plumber }

  let(:data) do
    {
      client_id: client.id,
      plumber_ids: [plumber_1.to_param, plumber_2.to_param],
      start_time: 1.hour.from_now,
      end_time: 3.hours.from_now,
    }
  end

  context 'with new job' do
    subject(:service) { described_class.call(data) }

    it 'creates a job' do
      expect { service }
        .to change(Job, :count).from(0).to(1)

      job = Job.first

      expect(job).to have_attributes(
        client: client,
        plumbers: contain_exactly(plumber_1, plumber_2),
        start_time: data[:start_time],
        end_time: data[:end_time]
      )
    end

    it 'fails if the times are invalid' do
      data[:end_time] = 1.hour.ago

      expect { service }.not_to change(Job, :count)

      expect(service.errors.full_messages).to contain_exactly('Start time must be earlier than end time')
    end

    it 'fails if the client is invalid' do
      data[:client_id] = 'invalid_id'

      expect { service }.not_to change(Job, :count)
      expect(service.errors.full_messages).to contain_exactly('Client #invalid_id is invalid')
    end

    it 'fails if there are invalid plumber_ids' do
      data[:plumber_ids] = ['invalid_id', plumber_2.to_param]

      expect { service }.not_to change(Job, :count)
      expect(service.errors.full_messages).to contain_exactly('The following plumber ids are invalid: invalid_id')
    end
  end

  context 'with existing job' do
    subject(:service) { described_class.call(data, job: job) }

    let!(:job) { create :job, client: client, plumbers: [plumber_1] }

    it 'updates the job' do
      expect { service }
        .to change(job.reload, :start_time)
        .and change(job, :end_time)
        .and change(job.plumbers, :count).from(1).to(2)
        .and change(job.versions, :count)
    end

    it 'returns an error if the job has already been completed' do
      job.update(done: true)

      expect { service }.not_to change(job.reload, :updated_at)
      expect(service.errors.full_messages).to contain_exactly('You cannot update a completed job')
    end
  end
end
