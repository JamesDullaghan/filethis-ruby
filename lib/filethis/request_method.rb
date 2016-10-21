module Filethis
  class RequestMethod
    attr_reader :name

    def initialize(name)
      @name = name.to_s
    end

    def self.call(name)
      client = Filethis::RequestMethod.new(name)

      client.method
    end
    # TODO : Too loud, can't think of better implementation
    def method
      if split_name.include?('create')
        :post
      elsif split_name.include?('update')
        :put
      elsif split_name.include?('destroy')
        :delete
      else
        :get
      end
    end

    def split_name
      name.split('_')
    end
  end
end
