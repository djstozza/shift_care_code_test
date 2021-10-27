require 'support/api_helpers/test_client'
require 'support/api_helpers/not_found_helper'

module APIHelpers
  def api
    @api ||= TestClient.new(self)
  end
end

RSpec.configure do |config|
  config.include APIHelpers, type: :request
end
