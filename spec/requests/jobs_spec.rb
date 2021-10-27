require 'rails_helper'

RSpec.describe 'api/jobs', type: :request do
  include ApplicationHelper
  let!(:admin) { create :admin }

  let!(:client) { create :client }
  let!(:plumber_1) { create :plumber }
  let!(:plumber_2) { create :plumber }
  let!(:plumber_3) { create :plumber }
  let!(:plumber_4) { create :plumber }

  let(:job_params) do
    {
      client_id: client.id,
      plumber_ids: [plumber_1.id, plumber_2.id],
      start_time: 3.hours.from_now,
      end_time: 4.hours.from_now,
      foo: [plumber_1.id, plumber_2.id],
      bar: plumber_1.id,
    }
  end

  before { api.authenticate(admin) }

  describe 'GET - Index' do
    let!(:job_1) do
      create(
        :job,
        start_time: 10.hours.ago,
        end_time: 5.hours.from_now,
        plumbers: [plumber_1]
      )
    end
    let!(:job_2) do
      create(
        :job,
        start_time: 10.hours.ago,
        end_time: 8.hours.ago,
        plumbers: [plumber_2, plumber_4]
      )
    end
    let!(:job_3) do
      create(
        :job,
        start_time: Time.current,
        end_time: 3.hours.from_now,
        plumbers: []
      )
    end
    let!(:job_4) do
      create(
        :job,
        start_time: 6.hours.from_now,
        end_time: 10.hours.from_now,
        plumbers: [plumber_1, plumber_3]
      )
    end

    it 'returns a list of jobs within a time period' do
      api.get api_jobs_path,
              params: {
                filter: {
                  start_time: 7.hours.ago,
                  end_time: 4.hours.from_now,
                },
                format: 'json',
              }

      expect(api.response).to have_http_status(:success)

      expect(api.data).to match(
        [
          a_hash_including(
            'id' => job_1.to_param,
            'client' => a_hash_including(
              'id' => job_1.client.to_param,
            ),
            'plumbers' => contain_exactly(
              a_hash_including(
                'id' => plumber_1.to_param
              ),
            )
          ),
          a_hash_including(
            'id' => job_3.to_param,
            'client' => a_hash_including(
              'id' => job_3.client.to_param,
            ),
            'plumbers' => [],
          ),
        ]
      )
    end

    it 'is filterable by plumber_id too' do
      api.get api_jobs_path,
              params: {
                filter: {
                  start_time: 7.hours.ago,
                  end_time: 4.hours.from_now,
                  plumber_id: plumber_1.id,
                },
                format: 'json',
              }

      expect(api.data).to match(
        [
          a_hash_including(
            'id' => job_1.to_param,
            'client' => a_hash_including(
              'id' => job_1.client.to_param,
            ),
            'plumbers' => contain_exactly(
              a_hash_including(
                'id' => plumber_1.to_param
              ),
            )
          ),
        ]
      )
    end
  end

  describe 'GET - Show' do
    let!(:job) { create :job }

    it 'returns the job' do
      api.get api_job_path(job), params: { format: 'json' }

      expect(api.data).to match(
        a_hash_including(
          'id' => job.to_param,
          'client' => a_hash_including(
            'id' => job.client.to_param,
          ),
          'plumbers' => [],
        )
      )
    end

    include_examples 'not found', 'job'
  end

  describe 'POST' do
    it 'creates a job' do
      expect do
        api.post api_jobs_path, params: { job: job_params, format: 'json' }
      end.to change(Job, :count).from(0).to(1)

      expect(api.response).to have_http_status(:success)

      job = Job.first

      expect(api.data).to include(
        'id' => job.to_param,
        'client' => a_hash_including(
          'id' => client.to_param
        ),
        'plumbers' => contain_exactly(
          a_hash_including(
            'id' => plumber_1.to_param
          ),
          a_hash_including(
            'id' => plumber_2.to_param
          )
        )
      )
    end

    it 'fails if the params are invalid' do
      invalid_params = {
        **job_params,
        start_time: nil,
      }

      api.post api_jobs_path, params: { job: invalid_params, format: 'json' }

      expect(api.response).to have_http_status(:unprocessable_entity)

      expect(api.errors).to contain_exactly(
        a_hash_including('detail' => "Start time can't be blank", 'source' => 'start_time'),
      )
    end

    it 'sets a new version with the admin as the initiator' do
      api.post api_jobs_path, params: { job: job_params, format: 'json' }

      job = Job.first

      expect(job.versions.last.whodunnit).to eq(name(admin))
    end
  end

  describe 'PUT' do
    let!(:job) { create :job }

    it 'updates the job' do
      api.put api_job_path(job), params: { job: job_params, format: 'json' }

      expect(api.response).to have_http_status(:success)

      expect(api.data).to include(
        'id' => job.to_param,
        'client' => a_hash_including(
          'id' => client.to_param
        ),
        'plumbers' => contain_exactly(
          a_hash_including(
            'id' => plumber_1.to_param
          ),
          a_hash_including(
            'id' => plumber_2.to_param
          )
        )
      )
    end

    it 'sets a new version with the admin as the initiator' do
      api.put api_job_path(job), params: { job: job_params, format: 'json' }

      expect(job.versions.last.whodunnit).to eq(name(admin))
    end

    it 'fails if the params are invalid' do
      invalid_params = {
        **job_params,
        start_time: nil,
      }

      api.put api_job_path(job), params: { job: invalid_params, format: 'json' }

      expect(api.response).to have_http_status(:unprocessable_entity)

      expect(api.errors).to contain_exactly(
        a_hash_including('detail' => "Start time can't be blank", 'source' => 'start_time'),
      )
    end
  end
end
