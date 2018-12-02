require 'test_helper'

class PlanDestroyTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @plan = plans(:one)
  end

  test "destroy should failed without login" do
    assert_no_difference 'Plan.count' do
      delete plan_path(@plan)
    end
    assert_redirected_to login_path
    follow_redirect!
    assert_template 'sessions/new'
    assert_not flash.empty?
  end

  test "destroy should failed with invalid user" do
    log_in_as(@other_user)
    assert_no_difference 'Plan.count' do
      delete plan_path(@plan)
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'static_pages/home'
    assert flash.empty?
  end

  test "destroy should success with valid user" do
    log_in_as(@user)
    assert_difference 'Plan.count', -1 do
      delete plan_path(@plan)
    end
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
