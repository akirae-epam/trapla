require 'test_helper'

class UserEditTestTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @valid_name = 'valid name'
    @valid_email = 'valid@email.com'
    @valid_password = 'foobar'
  end

  # 正常なユーザ名、パスワードでユーザ情報が変更できる（パスワード入力は不要）
  test "edit should be success with invalid user infomation" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {name: 'Edit username',
                                             email: 'edit@test.com'}}
    assert_redirected_to @user
    follow_redirect!
    assert_not flash.empty?
    assert_template 'users/show'
  end

  # 不正な情報では編集が失敗する
  test "edit should fail with invalid user infomation" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {name: '',
                                             email: ''}}
    assert_template 'users/edit'
  end

  #ログインしないとユーザ情報の編集はできない(get)
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  #ログインしないとユーザ情報の編集はできない(patch)
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email }}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  #他のユーザのユーザ情報は編集できない(get)
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  #他のユーザのユーザ情報は編集できない(patch)
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  #未ログインでユーザページにアクセス->ログイン後はユーザページにリダイレクト
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
