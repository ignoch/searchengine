module Parsers
  class Google < Base
    def data_root(body)
      body["items"]
    end

    def data_map(node)
      {
        name: node["title"],
        url: node["link"]
      }
    end
  end
end
