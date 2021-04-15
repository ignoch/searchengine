module Parsers
  class Google
    attr_accessor :response, :context

    def initialize(engine)
      @response = engine.search
      @context = Context.new
    end

    def results
      process
      context
    end

    private

    def process
      return context.fail!(response_error) unless valid?

      body = response.parsed_response
      context.collection = body["items"].map do |value|
        {
          name: value["title"],
          url: value["link"]
        }
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


