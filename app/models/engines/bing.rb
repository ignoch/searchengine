module Engines
  class Bing < Base

    def query_options
      {
        headers: { 'Ocp-Apim-Subscription-Key': access_key }
      }
    end

    def url
      "https://api.bing.microsoft.com/v7.0/search"
    end

    private

    def access_key
      ENV['BING_SUBSCRIPTION_ID'].to_s
    end
  end
end
