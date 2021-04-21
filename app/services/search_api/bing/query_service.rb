class SearchApi::Bing::QueryService < ApplicationService
  include HTTParty
  base_uri 'https://api.bing.microsoft.com'

  def initialize(search, params = {})
    @search = search
    offset = params.delete("offset") { 0 }

    @options = { query: params.merge({
      q: search, offset: offset
    }), headers: auth_header }
  end

  def call
    response = self.class.get('/v7.0/search', options)
    if success?(response)
      OpenStruct.new(success?: true, collection: parse_data(response))
    else
      OpenStruct.new(success?: false, error: parse_error(response))
    end
  end

  private
  attr_reader :options, :params

  def auth_header
    { 'Ocp-Apim-Subscription-Key': access_key }
  end

  def success?(response)
    response.code == 200
  end

  def parse_error(response)
    JSON.parse(response.body)["error"]["message"]
  end

  def parse_data(response)
    response.parsed_response["webPages"]["value"]
  end

  def access_key
    ENV['BING_SUBSCRIPTION_ID'].to_s
  end
end
