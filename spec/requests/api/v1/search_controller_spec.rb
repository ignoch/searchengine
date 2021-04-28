require 'rails_helper'

RSpec.describe "Api::V1::SearchController", type: :request do
  describe "POST /create" do
    it "should return unprocessable_entity error when engine is not defined" do
      post api_v1_search_url, params: {search: {engine: 'duckduckgo', text: 'coso'}}
      assert_response :unprocessable_entity
      assert_equal "EngineSearch not defined", JSON.parse(response.body).fetch("error")
    end

    context "Google Search" do
      it "should return data search" do
        VCR.use_cassette('google_valid_response') do
          post api_v1_search_url, params: {search: {engine: 'google', text: 'coso'}}
          assert_response :success
          assert_equal google_response, JSON.parse(response.body).fetch("data")
        end
      end

      it "should return data search with offset defined" do
        VCR.use_cassette('google_valid_response_with_offset') do
          post api_v1_search_url, params: { search: {engine: 'google', text: 'coso', offset:11 }}
          assert_response :success
          assert_equal google_response_offset, JSON.parse(response.body).fetch("data")
        end
      end

      it "should encode text data search" do
        VCR.use_cassette('google_red_wagon_response') do
          post api_v1_search_url, params: {search: {engine: 'google', text: 'red wagon!'}}
          assert_response :success
          assert_equal google_response_encoded, JSON.parse(response.body).fetch("data")
        end
      end

      it "should return empty data when text is empty" do
          post api_v1_search_url, params: {search: {engine: 'google', text: ''}}
          assert_response :success
          assert_equal [], JSON.parse(response.body).fetch("data")
      end

      it "should return empty data when engine is empty" do
          post api_v1_search_url, params: {search: {engine: '', text: 'coso'}}
          assert_response :success
          assert_equal [], JSON.parse(response.body).fetch("data")
      end

      it "should return unprocessable_entity error when engine is not defined" do
        post api_v1_search_url, params: {search: {engine: 'duckgogo', text: 'coso'}}
        assert_response :unprocessable_entity
        assert_equal "EngineSearch not defined", JSON.parse(response.body).fetch("error")
      end

      context "Bad API Key" do
        before do
          ENV['GOOGLE_CX_CODE'] = "InvalidCX"
        end

        it "should return unprocessable_entity error" do
          VCR.use_cassette('google_invalid_response') do
            post api_v1_search_url, params: {search: {engine: 'google', text: 'coso'}}
            assert_response :unprocessable_entity
            assert_equal "Request contains an invalid argument.", JSON.parse(response.body).fetch("error")
          end
        end
      end
    end

    context "Bing Search" do
      it "should return data search" do
        VCR.use_cassette('bing_valid_response') do
          post api_v1_search_url, params: {search: {engine: 'bing', text: 'coso'}}
          assert_response :success
          assert_equal bing_response, JSON.parse(response.body).fetch("data")
        end
      end

      it "should return data search with offset defined" do
        VCR.use_cassette('bing_valid_response_with_offset') do
          post api_v1_search_url, params: { search: {engine: 'bing', text: 'coso', offset:10 }}
          assert_response :success
          assert_equal bing_response_offset, JSON.parse(response.body).fetch("data")
        end
      end

      it "should encode text data search" do
        VCR.use_cassette('bing_red_wagon_response') do
          post api_v1_search_url, params: {search: {engine: 'bing', text: 'red wagon!'}}
          assert_response :success
          assert_equal bing_response_encoded, JSON.parse(response.body).fetch("data")
        end
      end

      it "should return empty data when text is empty" do
        post api_v1_search_url, params: {search: {engine: 'bing', text: ''}}
        assert_response :success
        assert_equal [], JSON.parse(response.body).fetch("data")
      end

      it "should return empty data when engine is empty" do
        post api_v1_search_url, params: {search: {engine: '', text: 'coso'}}
        assert_response :success
        assert_equal [], JSON.parse(response.body).fetch("data")
      end

      context "Bad API key" do
        before do
          ENV['BING_SUBSCRIPTION_ID'] = "InvalidID"
        end

        it "should return unprocessable_entity error" do
          VCR.use_cassette('bing_invalid_response') do
            post api_v1_search_url, params: {search: {engine: 'bing', text: 'coso'}}
            assert_response :unprocessable_entity
            assert_match /Access denied due to invalid subscription/ , JSON.parse(response.body).fetch("error")
          end
        end
      end
    end

    context "Both Search" do
      it "should return data search" do
        VCR.use_cassette('bing_valid_response') do
          VCR.use_cassette('google_valid_response') do
            post api_v1_search_url, params: {search: {engine: 'both', text: 'coso'}}
            assert_response :success
            assert_equal both_response.count, JSON.parse(response.body).fetch("data").count
          end
        end
      end

      it "should return valid data when one fails" do
        VCR.use_cassette('bing_valid_response') do
          VCR.use_cassette('google_invalid_response') do
            post api_v1_search_url, params: {search: {engine: 'both', text: 'coso'}}
            assert_response :success
            assert_equal bing_response, JSON.parse(response.body).fetch("data")
          end
        end
      end
    end
  end
end
