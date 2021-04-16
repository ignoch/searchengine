module Engines
  class Base
    attr_reader :keywords

    def initialize(keywords)
      @keywords = URI.encode_www_form_component(keywords)
    end

    def search(query_options)
      query_options = decorate_options(query_options)
      HTTParty.get(url, default_options.deep_merge(query_options))
    end

    def default_options
      {
        query: { q: keywords },
        headers: header_options
      }
    end

    def header_options
      {}
    end

    def decorate_options(options)
      options
    end

    def url
      raise "Implement me!"
    end
  end
end
