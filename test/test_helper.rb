ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require "webmock"
require "vcr"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('<GOOGLE_CX>') { ENV['GOOGLE_CX_CODE'] }
  c.filter_sensitive_data('<GOOGLE_KEY>') { ENV['GOOGLE_API_KEY'] }
  c.filter_sensitive_data('<BING_ID>'){ ENV['BING_SUBSCRIPTION_ID'] }
end
