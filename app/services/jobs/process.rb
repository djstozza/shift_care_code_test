class Jobs::Process < ApplicationService
  attr_reader :job,
              :start_time,
              :end_time,
              :client_id,
              :client,
              :plumber_ids,
              :plumbers

  validates :start_time,
            :end_time,
            :client_id,
            :plumber_ids,
            presence: true

  validate :valid_times
  validate :valid_client
  validate :valid_plumbers
  validate :job_still_active

  def initialize(data, job: nil)
    @job = job || Job.new
    @start_time = data[:start_time]
    @end_time = data[:end_time]
    @client_id = data[:client_id]
    @plumber_ids = data[:plumber_ids]
  end

  def call
    return unless valid?

    job.update(
      client: client,
      plumbers: plumbers,
      start_time: start_time,
      end_time: end_time
    )

    errors.merge!(job.errors) if job.errors.any?
  end

  private

  def valid_times
    return unless start_time.present? && end_time.present?
    return if start_time < end_time

    errors.add(:start_time, 'must be earlier than end time')
  end

  def valid_client
    return if client_id.blank?

    @client = Client.find_by(id: client_id)

    errors.add(:base, "Client ##{client_id} is invalid") if @client.blank?
  end

  def valid_plumbers
    return if plumber_ids.blank?

    @plumbers = Plumber.where(id: plumber_ids)
    invalid_ids = plumber_ids - @plumbers.ids.map(&:to_s)

    errors.add(:base, "The following plumber ids are invalid: #{invalid_ids.join(', ')}") if invalid_ids.any?
  end

  def job_still_active
    return unless job.done

    errors.add(:base, 'You cannot update a completed job')
  end
end
