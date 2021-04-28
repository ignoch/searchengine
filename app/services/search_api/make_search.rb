class SearchApi::MakeSearch < ApplicationService
  def initialize(query_params)
    @text   = query_params.delete("text") {""}
    @engine = query_params.delete("engine") {""}
    @query_params = query_params
  end

  def call
    return Context.empty_collection if text.empty? || engine.empty?

    case engine.downcase
    when 'google' then google_results
    when 'bing' then bing_results
    when 'both' then both_results
    else
      Context.fail!("EngineSearch not defined")
    end
  end

  private
  attr_reader :text, :engine, :query_params

  def google_results
    SearchApi::Google::SearchService.new(text, query_params).call
  end

  def bing_results
    SearchApi::Bing::SearchService.new(text, query_params).call
  end

  def both_results
    Context.new(
      collection:
      Array.wrap(bing_results.collection).concat(Array.wrap(google_results.collection)).uniq
    )
  end
end
