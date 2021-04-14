require "test_helper"

class Api::V1::SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_search_url
    assert_response :success
  end

  test "should get create" do
    post api_v1_search_url
    assert_response :success
  end
end
