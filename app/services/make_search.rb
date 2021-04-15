class MakeSearch
  def self.call(query_params)
    text = query_params["text"]
    engine = query_params["engine"]
    return [] if text.empty? || engine.empty?

    case engine.downcase
    when 'google' then google_results(text)
    when 'bing' then bing_results(text)
    when 'both' then both_results(text)
    else
      raise("UnknowEngineError")
    end
  end

  def self.google_results(text)
    Parsers::Google.new(Engines::Google.new(text)).results
  end

  def self.bing_results(text)
    Parsers::Bing.new(Engines::Bing.new(text)).results
  end

  def self.both_results(text)
    [bing_results(text),(google_results(text))].reduce([], :concat)
  end
end
