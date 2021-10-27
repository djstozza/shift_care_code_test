require 'rails_helper'

RSpec.describe Jobs::Complete, type: :service do
  subject(:service) { described_class.call({}, job: job) }

  let!(:job) { create :job }

  it 'marks a job as done' do
    expect { service }
      .to change(job.reload, :done).from(false).to(true)
  end

  it 'returns an error if the job has already been completed' do
    job.update(done: true)

    expect { service }.not_to change(job.reload, :updated_at)
    expect(service.errors.full_messages).to contain_exactly('You cannot update a completed job')
  end
end
