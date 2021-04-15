module Parsers
  class Google
    attr_accessor :response

    def initialize(engine)
      @response = engine.search
    end

    def results
      if valid?
        body = response.parsed_response
        body["items"].map do |value|
          {
            name: value["title"],
            url: value["link"]
          }
        end
      else
        response.body
      end
    end

    def valid?
      response.code == 200
    end
  end
end

