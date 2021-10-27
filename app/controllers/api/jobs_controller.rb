class Api::JobsController < Api::BaseController
  before_action :authenticate_admin!

  load_resource :job, only: %i[show update]

  def index
    respond_with JobSerializer.map(
      Job.filtered(filter_params[:start_time], filter_params[:end_time], filter_params[:plumber_id])
    )
  end

  def show
    respond_with serialized_job(job)
  end

  def create
    service = Jobs::Process.call(job_params)

    respond_with service.errors.any? ? service : serialized_job(service.job)
  end

  def update
    service = Jobs::Process.call(job_params, job: job)

    respond_with service.errors.any? ? service : serialized_job(service.job)
  end

  private

  def job_params
    params.require(:job).permit(
      :client_id,
      :start_time,
      :end_time,
      plumber_ids: []
    )
  end

  def filter_params
    params.fetch(:filter, {}).permit(
      :start_time,
      :end_time,
      :plumber_id
    )
  end

  def job
    Job.find(params[:id])
  end

  def serialized_job(job)
    JobSerializer.new(job)
  end
end
