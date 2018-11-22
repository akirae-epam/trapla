require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "user should not login with invalid infomation" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {email: '',
                                         password: ''}
                             }
    assert_template 'sessions/new'
    assert_select 'div.alert-danger'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "user should login with valid infomation" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {email: @user.email,
                                         password: 'password'}
                             }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', login_path, count:0
    delete logout_path
    assert_redirected_to root_url
    follow_redirect!
    assert_not is_logged_in?
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', signup_path
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
  end

end