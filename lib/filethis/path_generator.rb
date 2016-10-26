module Filethis
  class PathGenerator
    SPLIT_ACTIONS = %w(create update destroy)

    attr_reader :name

    def initialize(name)
      @name = name
    end

    def request_method
      Filethis::RequestMethod.call(name)
    end

    def path_names
      @path_names ||= name.to_s.split('_')
    end

    def path_without_req_meth
      @path_without_req_meth ||= path_names - (path_names & SPLIT_ACTIONS)
    end

    def path
      path_without_req_meth.map(&:pluralize).join('/')
    end
  end
end
