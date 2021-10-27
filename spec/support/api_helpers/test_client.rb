module APIHelpers
  class TestClient
    delegate :response, to: :session

    attr_reader :session
    attr_accessor :application, :admin, :auth

    def initialize(session)
      @session = session
      @results = Hash.new { |hash, key| hash[key] = {} }
    end

    def authenticate(admin)
      token = ::Admins::BaseService.call({}, admin: admin).token

      headers['Authorization'] = "Bearer #{token}"
    end

    def deuthenticate
      headers.delete('Authorization')
    end

    def headers
      @headers ||= {}
    end

    %i[get post put delete].each do |http_method|
      define_method(http_method) { |*args| process(http_method, *args) }
    end

    def process(method, path, headers: {}, **args)
      if (json = args.delete(:json))
        headers['Content-Type'] = 'application/json'
        args[:params] = json.to_json
      end

      session.process(
        method,
        path,
        headers: self.headers.merge(headers),
        **args
      )
    end

    def json
      fetch_result(:json) { JSON.parse(response.body) }
    end

    def data
      fetch_result(:data) { json['data'] }
    end

    def errors
      fetch_result(:errors) { json['errors'] }
    end

    def meta
      fetch_result(:errors) { json['meta'] }
    end

    def timestamp(*attrs)
      Time.zone.parse(data.dig(*attrs))
    end

    private

    def fetch_result(key)
      @results[response][key] ||= yield
    end
  end
end
