require 'test_helper'

class UserEditTestTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @valid_name = 'valid name'
    @valid_email = 'valid@email.com'
    @valid_password = 'foobar'
  end


  # 正常なユーザ名、パスワードでユーザ情報が変更できる（パスワード入力は不要）
  test "edit should be success with invalid user infomation" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {name: 'Edit username',
                                             email: 'edit@test.com'
                                            }
                                    }
    assert_redirected_to @user
    follow_redirect!
    assert_not flash.empty?
    assert_template 'users/show'
  end

  # 不正な情報では編集が失敗する
  test "edit should be fail with invalid user infomation" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {name: '',
                                             email: ''
                                            }
                                    }
    assert_template 'users/edit'
  end

end
