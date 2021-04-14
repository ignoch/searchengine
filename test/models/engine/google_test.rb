require 'test_helper'

class Engines::GoogleTest < ActiveSupport::TestCase
  def setup
    @google = Engines::Google.new('coso')
  end

  test 'valid keywords generate a url' do
    VCR.use_cassette('google_valid_response') do
      response = @google.search
      assert_equal 200, response.code
    end
  end
end
