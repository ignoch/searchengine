require 'test_helper'

class Engines::BingTest < ActiveSupport::TestCase
  def setup
    @bing = Engines::Bing.new('coso')
  end

  test 'valid keywords generate a url' do
    VCR.use_cassette('bing_valid_response') do
      response = @bing.search
      assert_equal 200, response.code
    end
  end

end
