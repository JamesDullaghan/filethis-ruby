module Filethis
  class HashPathGenerator < PathGenerator
    def initialize(name:, args:)
      @args = args
      @name = name
    end

    def path
      sigularize_last_resource if singular?
      generate_path
    end

    private

    attr_reader :name, :args

    def generate_path
      new_path = if request_method && request_method != :get
                   path_without_req_meth
                 else
                   # this will take ['partners', 'accounts'] and ['1', '2']
                   # and return /partners/1/accounts/2
                   path_names.zip(args[0].values).map(&:compact)
                 end

      new_path.join('/')
    end

    def sigularize_last_resource
      pluralized_path_names[-1] = last_resource.singularize
    end

    def singular?
      last_resource == last_resource.singularize &&
        last_resource != last_resource.pluralize &&
        path_names.size > 1
    end

    def pluralized_path_names
      @pluralized_path_names ||= path_names.map(&:pluralize)
    end

    def last_resource
      path_names[-1]
    end
  end
end
