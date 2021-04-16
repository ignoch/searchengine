module Parsers
  class Base
    attr_accessor :response, :context

    def initialize(engine, options={})
      @response = engine.search(options)
      @context = Context.new
    end

    def results
      process
      context
    end

    def data_root(body)
      []
    end

    def data_map(node)
      {}
    end

    private

    def process
      return context.fail!(response_error) unless valid?

      body = response.parsed_response
      context.collection = data_root(body).map do |node|
        data_map(node)
      end
    end

    def valid?
      response.code == 200
    end

    def response_error
      error_hash = if response.parsed_response.is_a?(String)
        JSON.parse(response.parsed_response)
      else
        response.parsed_response
      end
      error_hash["error"]["message"]
    end
  end
end
