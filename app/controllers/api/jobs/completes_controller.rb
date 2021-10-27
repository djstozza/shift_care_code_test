class Api::Jobs::CompletesController < Api::JobsController
  skip_before_action :authenticate_admin!

  load_resource :job

  def create
    service = Jobs::Complete.call({}, job: job)

    respond_with service.errors.any? ? service : serialized_job(service.job)
  end
end
