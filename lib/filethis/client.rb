module Filethis
  class Client
    class << self
      attr_accessor :api_key, :api_secret
    end

    attr_reader :path,
                :filethis_api_key,
                :filethis_api_secret,
                :opts,
                :request_method,
                :request_params

    def initialize(path, opts = {}, request_params = {})
      @path = path.present? ? path : ''
      @filethis_api_key = Filethis::Client.api_key || ENV['FILETHIS_API_KEY'] || opts[:api_key]
      @filethis_api_secret = Filethis::Client.api_secret || ENV['FILETHIS_API_SECRET'] || opts[:api_secret]
      @opts = opts.except(:api_key, :api_secret, :request_method) if opts.present?
      @request_method = opts[:request_method]
      @request_params = request_params
    end

    def self.request(path, opts, request_params)
      client = Filethis::Client.new(path, opts, request_params)
      client.parsed_response
    end

    def base_url
      @base_url ||= URI("https://filethis.com:443/api/v1/#{path}")
    end

    # TODO : Refactor
    def delete
      @request ||= Net::HTTP::Delete.new(base_url)
      @request.basic_auth filethis_api_key, filethis_api_secret
      @request["content-type"] = 'application/json'
      @request["cache-control"] = 'no-cache'
      @request.body = request_params.to_json
      @request
    end

    def put
      @request ||= Net::HTTP::Put.new(base_url)
      @request.basic_auth filethis_api_key, filethis_api_secret
      @request["content-type"] = 'application/json'
      @request["cache-control"] = 'no-cache'
      @request.body = request_params.to_json
      @request
    end

    def post
      @request ||= Net::HTTP::Post.new(base_url)
      @request.basic_auth filethis_api_key, filethis_api_secret
      @request["content-type"] = 'application/json'
      @request["cache-control"] = 'no-cache'
      @request.body = request_params.to_json
      @request
    end

    def get
      @request ||= Net::HTTP::Get.new(base_url)
      @request.basic_auth filethis_api_key, filethis_api_secret
      @request["cache-control"] = 'no-cache'
      @request
    end

    def http
      @http ||= Net::HTTP.new(base_url.host, base_url.port)
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      puts "#{request_method} : #{base_url.to_s}"
      @http
    end

    def req_method
      request_method.to_sym
    end

    def response
      @response ||= http.request(self.send(req_method))
    end

    def parsed_response
      @parsed_response ||= if req_method != :delete
        JSON.parse(response.read_body, quirks_mode: true)
      end
    rescue JSON::ParserError => e
      Rails.logger.error("This endpoint URL does not exist or has moved : #{e.inspect}")
    end
  end
end
