require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  test "signup user" do
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
  end

  test "invalid signup user infomation" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 0 do
      post signup_path, params: { user: {name: '', email: '' }}
    end
    assert_template 'users/new'
  end

end
