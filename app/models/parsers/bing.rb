module Parsers
  class Bing < Base

    def data_root(body)
      body["webPages"]["value"]
    end

    def data_map(node)
      {
        name: node["name"],
        url: node["url"]
      }
    end
  end
end
