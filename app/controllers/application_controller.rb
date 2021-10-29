require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  before_action :handle_html_requests

  # Avoid having an empty view file.
  def index
  end

  private

  # Required for initial page load so that the entire app isn't served as json
  def handle_html_requests
    render 'layouts/application' if request.format.symbol == :html
  end
end
