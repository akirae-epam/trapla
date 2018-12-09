# frozen_string_literal: true

require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @test_user = users(:lana)
    @valid_name = 'valid name'
    @valid_email = 'valid@email.com'
    @valid_password = 'foobar'
  end

  # 正常なユーザ名、パスワードでユーザ情報が変更できる（パスワード入力は不要）
  test 'edit should be success with invalid user infomation' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: 'Edit username',
                                              email: 'edit@test.com' } }
    assert_redirected_to @user
    follow_redirect!
    assert_not flash.empty?
    assert_template 'users/show'
  end

  # 不正な情報では編集が失敗する
  test 'edit should fail with invalid user infomation' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: '' } }
    assert_template 'users/edit'
  end

  # ログインしないとユーザ情報の編集はできない(get)
  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  # ログインしないとユーザ情報の編集はできない(patch)
  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # 他のユーザのユーザ情報は編集できない(get)
  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  # 他のユーザのユーザ情報は編集できない(patch)
  test 'should redirect update when logged in as wrong user' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  # 未ログインでユーザページにアクセス->ログイン後はユーザページにリダイレクト
  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

  # 管理者でないと管理者権限を付与できない
  test 'should not allow the admin attribute to be edited via the web' do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
      user: { password: @valid_password,
              password_confirmation: @valid_password,
              admin: true }
    }
    assert_not @other_user.reload.admin?
  end

  # 削除権限は自分自身か管理者が持つ
  test 'user cannot be deleted with not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@other_user)
    end
    assert_redirected_to login_url
    assert_not flash.empty?
  end

  test 'user can delete only own self' do
    log_in_as(@other_user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to root_url
    assert_not flash.empty?
  end

  test 'user cannot delete another' do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@test_user)
    end
    assert_redirected_to root_url
  end

  test 'admin user allowed to delete another' do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to users_url
    assert_not flash.empty?
  end

  # プロフィール画像のアップロード失敗（ファイルサイズオーバー）
  test 'upload should fail with over 5MB image' do
    log_in_as(@user)
    bigfile = fixture_file_upload('test/fixtures/image_invalid_filesize.png',
                                  'image/png')
    assert_not @user.user_image.attached?
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email,
                                              new_user_image: bigfile } }
    assert_not @user.user_image.attached?
    assert_select '.alert-danger'
  end

  # プロフィール画像のアップロード失敗（不正な拡張子）
  #  ---------   いまんとこバリデーション不可能   ----------
  # test "upload should fail with invalid file name" do
  #   log_in_as(@user)
  #   bigfile = fixture_file_upload('filename', 'image/png')
  #   assert_not @user.user_image.attached?
  #   patch user_path(@user), params: {user: {name: @user.name,
  #                                           email: @user.email,
  #                                           new_user_image: bigfile}}
  #   assert_not @user.user_image.attached?
  #   assert_select '.alert-danger'
  # end

  # プロフィール画像のアップロード成功
  test 'upload should success' do
    log_in_as(@user)
    validfile = fixture_file_upload('test/fixtures/image_valid.png',
                                    'image/png')
    assert_not @user.user_image.attached?
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email,
                                              new_user_image: validfile } }
    assert @user.reload.user_image.attached?
    assert_select '.alert-danger', count: 0
  end
end
