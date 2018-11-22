require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  test "signup with valid user infomation" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: {name: 'Test User',
                                         email: 'user@test.com',
                                         password: 'foobar',
                                         password_confirmation: 'foobar' }}
    end
    follow_redirect!
    assert_not flash.empty?
    assert_template 'users/show'
    assert is_logged_in?
  end

  test "signup with invalid  user infomation" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post signup_path, params: { user: {name: '', email: '',password: '',password_confirmation: '' }}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end

end
