class Jobs::BaseService < ApplicationService
  attr_reader :job,
              :start_time,
              :end_time,
              :client_id,
              :client,
              :plumber_ids,
              :plumbers

  validate :job_still_active

  def initialize(data, job: nil)
    @job = job || Job.new
    @start_time = data[:start_time]
    @end_time = data[:end_time]
    @done = data[:done]
    @client_id = data[:client_id]
    @plumber_ids = data[:plumber_ids]
  end

  private

  def job_still_active
    return unless job.done

    errors.add(:base, 'You cannot update a completed job')
  end
end
