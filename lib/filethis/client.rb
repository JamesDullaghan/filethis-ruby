module Filethis
  class Client
    attr_reader :path,
                :ticket,
                :opts,
                :request_method

    attr_accessor :account_id

    def initialize(path, opts = {})
      @path = path.present? ? path : ''
      @ticket = ENV['FILETHIS_TICKET'] || opts[:ticket]
      @opts = opts.except(:ticket, :request_method) if opts.present?
      @request_method = opts[:request_method]
      @account_id = nil
    end

    # Filethis::Client.fetch('partners', { id: 1, ticket: 'some_ticket' })
    # ticket and ID are optional.
    def self.collection(path, opts = {})
      client = Filethis::Client.new(path, opts)
      client.parsed_response
    end

    def self.member(path, id = nil, opts = {})
      # this will fetch the member if the path is defined with id's
      # ex.) /partners/1/changes/1
      collection_obj = collection(path, opts)

      return collection_obj unless id
      # We don't fetch when id is supplied as a string, we find from collection
      collection_obj.find { |el| el['id'].to_i == id.to_i }
    end

    def base_url
      @base_url ||= URI("https://filethis.com:443/api/v1/#{path}?ticket=#{ticket}")
    end

    # TODO : Refactor
    def delete
      @request ||= Net::HTTP::Delete.new(base_url)
      @request["content-type"] = 'application/json'
      @request["cache-control"] = 'no-cache'
      @request.body = opts.to_json
      @request
    end

    def put
      @request ||= Net::HTTP::Put.new(base_url)
      @request["content-type"] = 'application/json'
      @request["cache-control"] = 'no-cache'
      @request.body = opts.to_json
      @request
    end

    def post
      @request ||= Net::HTTP::Post.new(base_url)
      @request["content-type"] = 'application/json'
      @request["cache-control"] = 'no-cache'
      @request.body = opts.to_json
      @request
    end

    def get
      @request ||= Net::HTTP::Get.new(base_url)
      @request["cache-control"] = 'no-cache'
      @request
    end

    def http
      @http ||= Net::HTTP.new(base_url.host, base_url.port)
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      puts base_url.to_s
      @http
    end

    def response
      @response ||= http.request(self.send(request_method.to_sym))
    end

    def parsed_response
      @parsed_response ||= JSON.parse(response.read_body, quirks_mode: true)
    rescue JSON::ParserError => e
      Rails.logger.error("This endpoint URL does not exist or has moved : #{e.inspect}")
    end
  end
end
