require 'test_helper'

class Parsers::BingTest < ActiveSupport::TestCase
  def setup
    @engine = Engines::Bing.new("coso")
  end

  test "when data is valid" do
    VCR.use_cassette('bing_valid_response') do
      result = Parsers::Bing.new(@engine).results
      assert_includes result.collection, {:name=>"Welcome to COSO", :url=>"https://www.coso.org/Pages/default.aspx"}
    end
  end
end

