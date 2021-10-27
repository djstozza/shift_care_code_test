class Api::BaseController < ApplicationController
  before_action :process_token

  respond_to :json

  include ::ResourceLoading
  include ErrorSerialization

  private

  def respond_with(resource, **meta)
    if resource.respond_to?(:errors) && resource.errors.present?
      render json: serialized_errors(resource), status: meta[:status] || :unprocessable_entity
    else
      render json: { meta: meta, data: resource }
    end
  end

  # Check for auth headers - if present, decode or send unauthorized response (called always to allow current_admin)
  def process_token
    service = Auth::ProcessToken.call(request)

    return respond_with service, status: :unauthorized if service.errors.any?

    @current_admin_id = service.current_admin_id
  end

  # If admin has not signed in, return unauthorized response (called only when auth is needed)
  def authenticate_admin!(_options = {})
    head :unauthorized unless signed_in?
  end

  # set Devise's current_admin using decoded JWT instead of session
  def current_admin
    @current_admin ||= super || Admin.find(@current_admin_id)
  end

  # check that authenticate_admin has successfully returned @current_admin_id (admin is authenticated)
  def signed_in?
    @current_admin_id.present?
  end
end
