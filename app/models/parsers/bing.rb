module Parsers
  class Bing
    attr_accessor :response

    def initialize(engine)
      @response = engine.search
    end

    def results
      if valid?
        body = response.parsed_response
        body["webPages"]["value"].map do |value|
          {
            name: value["name"],
            url: value["url"]
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
