# frozen_string_literal: true

require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  def setup
    # 各テストを実施するまえにメールボックスをクリア
    ActionMailer::Base.deliveries.clear
  end

  test 'signup with valid user infomation' do
    # サインアップページにアクセスして登録情報を送信
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'Test User',
                                          email: 'user@test.com',
                                          password: 'foobar',
                                          password_confirmation: 'foobar' } }
    end
    user = assigns(:user)
    assert_not user.activated?
    follow_redirect!
    assert_not flash.empty?
    assert_template 'static_pages/home'
    assert_equal 1, ActionMailer::Base.deliveries.size

    # 有効化していない状態でログインしてみる
    log_in_as(user)
    assert_not is_logged_in?
    # 有効化トークンが不正な場合
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token,
                                     email: 'wrong mail address')
    assert_not is_logged_in?

    # 正しい有効化トークンとメールアドレスで有効化
    get edit_account_activation_url(user.activation_token, email: user.email)
    assert user.reload.activated?
    assert_redirected_to user
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

  # 不正な情報ではサインアップできない
  test 'signup with invalid  user infomation' do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: '',
                                          email: '',
                                          password: '',
                                          password_confirmation: '' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end
end
