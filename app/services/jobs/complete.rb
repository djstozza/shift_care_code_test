class Jobs::Complete < Jobs::BaseService
  validates :job, presence: true

  def call
    return unless valid?

    job.update(done: true)

    errors.merg!(job.errors) if errors.any?
  end
end
