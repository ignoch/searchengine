require 'test_helper'

class Parsers::GoogleTest < ActiveSupport::TestCase
  def setup
    @engine = Engines::Google.new("coso")
  end

  test "when data is valid" do
    VCR.use_cassette('google_valid_response') do
      result = Parsers::Google.new(@engine).results
      assert_includes result.collection, {:name=>"Welcome to COSO", :url=>"https://www.coso.org/Pages/default.aspx"}
    end
  end
end
