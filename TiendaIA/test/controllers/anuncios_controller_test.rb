require "test_helper"

class AnunciosControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get anuncios_new_url
    assert_response :success
  end

  test "should get create" do
    get anuncios_create_url
    assert_response :success
  end

  test "should get show" do
    get anuncios_show_url
    assert_response :success
  end
end
