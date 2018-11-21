require 'test_helper'

class UserEditTestTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "edit user" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {name: 'Edit username',
                                             email: 'edit@test.com',
                                             password: 'foobar',
                                             password_confirmation: 'foobar'
                                            }
                                    }
    assert_redirected_to @user
    follow_redirect!
    assert_not flash.empty?
    assert_template 'users/show'
  end

  test "invalid signup user infomation" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {name: '', email: '' }}
    assert_template 'users/edit'
  end

end
