module Engines
  class Base

    def initialize(keywords)
      @keywords = URI.encode_www_form_component(keywords)
    end

    def search
      HTTParty.get(url, default_options.merge(query_options))
    end

    def query_options
      {}
    end

    def url
      raise "Implement me!"
    end

    private

    attr_reader :keywords

    def default_options
      {
        query: { q: keywords },
      }
    end
  end
end
