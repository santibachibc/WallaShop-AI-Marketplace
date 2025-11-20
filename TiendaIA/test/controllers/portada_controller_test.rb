require "test_helper"

class PortadaControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get portada_home_url
    assert_response :success
  end
end
