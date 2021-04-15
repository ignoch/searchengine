module Parsers
  class Base
    attr_accessor :response, :context

    def initialize(engine)
      @response = engine.search
      @context = Context.new
    end

    def results
      process
      context
    end

    def data_root
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
      response.parsed_response["error"]["message"]
    end
  end
end
