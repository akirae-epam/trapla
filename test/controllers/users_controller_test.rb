require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @not_activated_user = users(:snake)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should get user/show" do
    get user_path(@user)
    assert_response :success
  end

  #ログインしないとindexは見られない
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  # 有効化されていないshowページはアクセスできない
  test "should redrect root without user activated" do
    log_in_as(@user)
    get user_path(@not_activated_user)
    assert_redirected_to root_url
  end

end
