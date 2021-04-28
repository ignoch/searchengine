class SearchApi::Google::QueryService < ApplicationService
  include HTTParty
  base_uri 'https://www.googleapis.com/customsearch'

  def initialize(search, params={})
    @search = search
    @options = build_options(search, params)
  end

  def call
    response = self.class.get('/v1', options)
    if success?(response)
      OpenStruct.new(success?: true, collection: parse_data(response))
    else
      OpenStruct.new(success?: false, error: parse_error(response))
    end
  end

  private
  attr_reader :options, :params

  def build_options(search, params)
    offset = params.delete("offset") { 1 }
    params = params.merge(auth_query_params)
    {
      query: params.merge({
        q: search, start: offset
      })
    }
  end

  def auth_query_params
    {
      key: api_key,
      cx: cx_code
    }
  end

  def success?(response)
    response.code == 200
  end

  def parse_error(response)
    JSON.parse(response.body)["error"]["message"]
  end

  def parse_data(response)
    response.parsed_response["items"]
  end

  def api_key
    ENV['GOOGLE_API_KEY'].to_s
  end

  def cx_code
    ENV['GOOGLE_CX_CODE'].to_s
  end
end
