# TODO : Cleanup, this is a mess.
# Notes : Some singular api endpoint urls are /plural/id/singular
# In order to handle these endpoints, the method definition is singular
# ex.) def self.accounts_referral_link({ account_id: })
#  /v1/accounts/:account_id/referrals/link
module Filethis
  class Base
    def self.method_missing(name, *args, &block)
      request_method = Filethis::RequestMethod.call(name)
      path = Filethis::PathGenerator.new(name: name).path

      if string_or_int?(args)
        # ex.) Filethis::Client.member('/accounts', '36')
        Filethis::Client.member(path, args[0], { request_method: request_method })
      elsif hash?(args)
        # ex.) Filethis::Client.member('/accounts/21/connections/21')
        path = Filethis::HashPathGenerator.new(name: name, args: args).path
        Filethis::Client.member(path, nil, args[0].merge(request_method: request_method))
      else
        Filethis::Client.collection(path, { request_method: request_method })
      end
      rescue StandardError => e
        LOGGER.error("Filethis Path Attempted : #{path}")
        LOGGER.error(e.inspect)
    end

    def self.string_or_int?(args)
      string_or_int = (args[0].is_a?(Integer) || args[0].is_a?(String))
      args.present? && string_or_int
    end

    def self.hash?(args)
      args.present? && args[0].is_a?(Hash)
    end

    def get?(args)
      args.present? && args[0].fetch(:req_method) { :get } == :get
    end

    def post?(args)
      args.present? && args[0].fetch(:req_method) == :post
    end
  end
end
