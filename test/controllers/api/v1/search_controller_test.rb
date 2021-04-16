require "test_helper"

class Api::V1::SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_search_url
    assert_response :success
  end

  test "should return unprocessable_entity error when engine is not defined" do
    post api_v1_search_url, params: {search: {engine: 'duckduckgo', text: 'coso'}}
    assert_response :unprocessable_entity
    assert_equal "EngineSearch not defined", JSON.parse(response.body).fetch("error")
  end

  class GoogleSearchTest < ActionDispatch::IntegrationTest

    test "should return data search" do
      VCR.use_cassette('google_valid_response') do
        post api_v1_search_url, params: {search: {engine: 'google', text: 'coso'}}
        assert_response :success
        assert_equal ApiResponse.google_response, JSON.parse(response.body).fetch("data")
      end
    end

    test "should return data search with offset defined" do
      VCR.use_cassette('google_valid_response_with_offset') do
        post api_v1_search_url, params: { search: {engine: 'google', text: 'coso', offset:11 }}
        assert_response :success
        assert_equal ApiResponse.google_response_offset, JSON.parse(response.body).fetch("data")
      end
    end

    test "should encode text data search" do
      VCR.use_cassette('google_red_wagon_response') do
        post api_v1_search_url, params: {search: {engine: 'google', text: 'red wagon!'}}
        assert_response :success
        assert_equal ApiResponse.google_response_encoded, JSON.parse(response.body).fetch("data")
      end
    end

    test "should return empty data when text is empty" do
        post api_v1_search_url, params: {search: {engine: 'google', text: ''}}
        assert_response :success
        assert_equal [], JSON.parse(response.body).fetch("data")
    end

    test "should return empty data when engine is empty" do
        post api_v1_search_url, params: {search: {engine: '', text: 'coso'}}
        assert_response :success
        assert_equal [], JSON.parse(response.body).fetch("data")
    end

    test "should return unprocessable_entity error when engine is not defined" do
      post api_v1_search_url, params: {search: {engine: 'duckgogo', text: 'coso'}}
      assert_response :unprocessable_entity
      assert_equal "EngineSearch not defined", JSON.parse(response.body).fetch("error")
    end

    class ErrorFromGoogle < ActionDispatch::IntegrationTest
      def setup
        ENV['GOOGLE_CX_CODE'] = "InvalidCX"
      end

      test "should return unprocessable_entity error" do
        VCR.use_cassette('google_invalid_response') do
          post api_v1_search_url, params: {search: {engine: 'google', text: 'coso'}}
          assert_response :unprocessable_entity
          assert_equal "Request contains an invalid argument.", JSON.parse(response.body).fetch("error")
        end
      end
    end
  end

  class BingSearchTest < ActionDispatch::IntegrationTest
    test "should return data search" do
      VCR.use_cassette('bing_valid_response') do
        post api_v1_search_url, params: {search: {engine: 'bing', text: 'coso'}}
        assert_response :success
        assert_equal ApiResponse.bing_response, JSON.parse(response.body).fetch("data")
      end
    end

    test "should return data search with offset defined" do
      VCR.use_cassette('bing_valid_response_with_offset') do
        post api_v1_search_url, params: { search: {engine: 'bing', text: 'coso', offset:10 }}
        assert_response :success
        assert_equal ApiResponse.bing_response_offset, JSON.parse(response.body).fetch("data")
      end
    end

    test "should encode text data search" do
      VCR.use_cassette('bing_red_wagon_response') do
        post api_v1_search_url, params: {search: {engine: 'bing', text: 'red wagon!'}}
        assert_response :success
        assert_equal ApiResponse.bing_response_encoded, JSON.parse(response.body).fetch("data")
      end
    end

    test "should return empty data when text is empty" do
        post api_v1_search_url, params: {search: {engine: 'bing', text: ''}}
        assert_response :success
        assert_equal [], JSON.parse(response.body).fetch("data")
    end

    test "should return empty data when engine is empty" do
        post api_v1_search_url, params: {search: {engine: '', text: 'coso'}}
        assert_response :success
        assert_equal [], JSON.parse(response.body).fetch("data")
    end


    class ErrorFromBing < ActionDispatch::IntegrationTest
      def setup
        ENV['BING_SUBSCRIPTION_ID'] = "InvalidID"
      end

      test "should return unprocessable_entity error" do
        VCR.use_cassette('bing_invalid_response') do
          post api_v1_search_url, params: {search: {engine: 'bing', text: 'coso'}}
          assert_response :unprocessable_entity
          assert_match /Access denied due to invalid subscription/ , JSON.parse(response.body).fetch("error")
        end
      end
    end
  end

  class BothSearchTest < ActionDispatch::IntegrationTest
    test "should return data search" do
      VCR.use_cassette('bing_valid_response') do
        VCR.use_cassette('google_valid_response') do
          post api_v1_search_url, params: {search: {engine: 'both', text: 'coso'}}
          assert_response :success
          assert_equal ApiResponse.both_response.count, JSON.parse(response.body).fetch("data").count
        end
      end
    end

    test "should return valid data when one fails" do
      VCR.use_cassette('bing_valid_response') do
        VCR.use_cassette('google_invalid_response') do
          post api_v1_search_url, params: {search: {engine: 'both', text: 'coso'}}
          assert_response :success
          assert_equal ApiResponse.bing_response, JSON.parse(response.body).fetch("data")
        end
      end
    end
  end
end
