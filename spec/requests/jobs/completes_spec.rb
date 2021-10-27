require 'rails_helper'

RSpec.describe 'api/jobs/completes', type: :request do
  let!(:job) { create :job }

  it 'marks the job as done' do
    api.post api_job_complete_path(job), params: { format: 'json' }
    # expect { api.post api_job_complete_path(job), params: { format: 'json' } }
    #   .to change(job.reload, :done).from(false).to(true)

    expect(api.data).to include(
      'id' => job.to_param,
      'client' => a_hash_including(
        'id' => job.client.to_param,
      ),
      'plumbers' => [],
      'done' => true
    )
  end

  it 'renders errors if invalid' do
    job.update(done: true)

    api.post api_job_complete_path(job), params: { format: 'json' }

    expect(api.response).to have_http_status(:unprocessable_entity)

    expect(api.errors).to contain_exactly(
      a_hash_including('detail' => 'You cannot update a completed job'),
    )
  end
end
