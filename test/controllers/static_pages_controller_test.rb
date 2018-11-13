require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_path
    assert_response :success
    assert_select 'title', "Trapla"
  end

  test "should get help" do
    get help_url
    assert_response :success
    assert_select 'title', "Help | Trapla"
  end

  test "should get about" do
    get about_url
    assert_response :success
    assert_select 'title', "About | Trapla"
  end

end
