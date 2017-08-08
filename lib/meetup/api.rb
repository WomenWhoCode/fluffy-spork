require 'rack'
require 'nitlink/response'

module Meetup
  class Api
    OK = 200
    BASE_URI = 'api.meetup.com'

    attr_accessor :remaining_requests, :reset_seconds

    def initialize(data_type:, options: {})
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
      throttle_wait
      @response = do_request
      if @response.status.code == 304
        MMLog.log.debug("No modifications to response since request was last made. Delete watermark etag for watermark id #{@watermark.id} to re-run data.")
        return {}
      else
        set_throttle_values
        get_body
      end

      rescue => e
        Bugsnag.notify("Error parsing Meetup response: #{e}") do |notification|
          notification.grouping_hash = e.class.to_s + e.message
          notification.add_tab(:meetup, {
            request_url: sanitized_url,
            response: @response.to_a,
            remaining_requests: @remaining_requests,
            reset_seconds: @reset_seconds
          })
        end
        return {}
    end

    def build_url
      query_string = Rack::Utils.build_query(@options)
      "#{base_url}?#{query_string}"
    end

    def throttle_wait
      return if remaining_requests > 0
      sleep reset_seconds
    end

    def update_watermark
      @watermark.update(etag: @response.headers.get("etag").first)
    end

    def get_next_page(until_date=nil)
      @url = pagination_link(until_date)
      get_response if @url
    end

    def reset_data_options(data_type:, options: {})
      @data_type = data_type
      @options = options
      @options[:key] = ENV['MEETUP_KEY']
      @url = build_url
    end

    def sanitized_url
      @url.gsub(/key=[a-f0-9]+/,'key=sanitized')
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
        update_watermark
        body
      else
        errors = body["errors"] || [{"message": "Meetup response has no body"}]
        raise errors.map { |h| h["message"] }.join("; ")
      end
    end

    def response_success?
      @response && @response.code == OK
    end

    private

    def do_request
      @url ||= build_url
      MMLog.log.debug(sanitized_url)

      @watermark = Watermark.where(url: sanitized_url).first_or_initialize
      etag_str = %Q|#{@watermark.etag}|
      HTTP.headers('If-None-Match' => "#{etag_str}").get(@url)
    end

    def pagination_link(until_date)
      target = @response.links.by_rel('next').try(:target)
      return target.to_s if target && !until_date

      if target && target.to_s =~ /scroll=since%3A(\d{4}-\d{2}-\d{2})/
        since_date = Date.strptime($1, "%Y-%m-%d")
        since_date < until_date ? target.to_s : nil
      end
    end
  end
end
