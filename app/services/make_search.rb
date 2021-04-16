class MakeSearch
  def self.call(query_params)
    text = query_params.delete("text") {""}
    engine = query_params.delete("engine") {""}
    return Context.new(collection: []) if text.empty? || engine.empty?

    case engine.downcase
    when 'google' then google_results(text, query_params)
    when 'bing' then bing_results(text, query_params)
    when 'both' then both_results(text, query_params)
    else
      Context.fail!("EngineSearch not defined")
    end
  end

  def self.google_results(text, options)
    Parsers::Google.new(Engines::Google.new(text), options).results
  end

  def self.bing_results(text, options)
    Parsers::Bing.new(Engines::Bing.new(text), options).results
  end

  def self.both_results(text, options)
    Context.new(
      collection:
      Array.wrap(bing_results(text, options).collection).concat(Array.wrap(google_results(text, options).collection)).uniq
    )
  end
end
