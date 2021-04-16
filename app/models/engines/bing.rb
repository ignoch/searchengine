module Engines
  class Bing < Base
    def header_options
      { 'Ocp-Apim-Subscription-Key': access_key }
    end

    def url
      "https://api.bing.microsoft.com/v7.0/search"
    end

    def decorate_options(options)
      offset = options.fetch("offset", 0)
      {
        query: { offset: offset }
      }
    end

    private

    def access_key
      ENV['BING_SUBSCRIPTION_ID'].to_s
    end
  end
end
