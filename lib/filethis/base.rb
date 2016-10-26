# TODO : Cleanup, this is a mess.
# Notes : Some singular api endpoint urls are /plural/id/singular
# In order to handle these endpoints, the method definition is singular
# ex.) def self.accounts_referral_link({ account_id: })
#  /v1/accounts/:account_id/referrals/link
module Filethis
  class Base
    def self.method_missing(name, *args, &block)
      request_method = Filethis::RequestMethod.call(name)
      path = Filethis::HashPathGenerator.path(name, args, request_method)

      # If no arguments passed, it's a base get request ex.) /accounts
      path_params = args[0] || {}
      path_params = path_params.merge(request_method: request_method)
      request_params = args[1] || {}

      Filethis::Client.request(path, path_params, request_params)
    rescue StandardError => e
      LOGGER.error("Filethis Path Attempted : #{path}")
      LOGGER.error(e.inspect)
    end
  end
end
