require 'rack'

module Meetup
  class Api
    OK = 200
    BASE_URI = 'api.meetup.com'

    attr_accessor :remaining_requests, :reset_seconds

    def initialize(data_type:, options:)
      @data_type = data_type
      @options = options
      @options[:key] = ENV['MEETUP_KEY']
      @remaining_requests = 1
      @reset_seconds = 1
    end

    # https://www.meetup.com/meetup_api/docs/#making_request
    # https://www.meetup.com/meetup_api/docs/#responses
    # https://www.meetup.com/meetup_api/docs/#errors
    def get_response
      url = build_url
      MMLog.log.debug(url)
      throttle_wait
      @response = HTTP.get(url)
      set_throttle_values
      get_body

      rescue => e
        Bugsnag.notify("Error parsing Meetup response: #{e}")
        { "errors" => [{"message": "Error parsing Meetup response"}] }
    end

    def build_url
      query_string = Rack::Utils.build_query(@options)
      "#{base_url}?#{query_string}"
    end

    def throttle_wait
      return if remaining_requests > 0
      sleep reset_seconds
    end

    protected

    def base_url
      "https://#{BASE_URI}/#{@data_type.join('/')}/"
    end

    def set_throttle_values
      headers = @response.headers
      self.remaining_requests = headers.get("X-Ratelimit-Remaining").first.to_i
      self.reset_seconds = headers.get("X-Ratelimit-Reset").first.to_i
    end

    def get_body
      body = @response.parse(:json)

      if response_success?
        body
      else
        errors = body["errors"] || [{"message": "Meetup response has no body"}]
        raise errors.map { |h| h["message"] }.join("; ")
      end
    end

    def response_success?
      @response && @response.code == OK
    end
  end
end
