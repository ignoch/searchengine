class MakeSearch
  def self.call(query_params)
    text = query_params.fetch("text", "")
    engine = query_params.fetch("engine", "")
    return Context.new(collection: []) if text.empty? || engine.empty?

    case engine.downcase
    when 'google' then google_results(text)
    when 'bing' then bing_results(text)
    when 'both' then both_results(text)
    else
      Context.fail!("EngineSearch not defined")
    end
  end

  def self.google_results(text)
    Parsers::Google.new(Engines::Google.new(text)).results
  end

  def self.bing_results(text)
    Parsers::Bing.new(Engines::Bing.new(text)).results
  end

  def self.both_results(text)
    Context.new(
      collection:
      Array.wrap(bing_results(text).collection).concat(Array.wrap(google_results(text).collection)).uniq
    )
  end
end
