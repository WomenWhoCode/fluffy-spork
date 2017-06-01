require 'rack'
require 'MMLog'

module Meetup
  class Api
    OK = '200'
    BASE_URI = 'api.meetup.com'

    def initialize(data_type:, options:)
      @data_type = data_type
      @options = options
      @options[:key] = ENV['MEETUP_KEY']
    end

    # https://www.meetup.com/meetup_api/docs/#making_request
    # https://www.meetup.com/meetup_api/docs/#responses
    # https://www.meetup.com/meetup_api/docs/#errors
    def get_response
      url = build_url
      MMLog.log.debug(url)
      @response = HTTP.get(url)
      @response.parse(:json)

      rescue => e
        Bugsnag.notify("Error parsing Meetup response: #{e}")
        { "errors" => [{"message": "Error parsing Meetup response"}] }
    end

    def build_url
      query_string = Rack::Utils.build_query(@options)
      "#{base_url}?#{query_string}"
    end

    protected

    def base_url
      "https://#{BASE_URI}/#{@data_type.join('/')}/"
    end
  end
end
