require 'test_helper'

class PlanCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "create should failed without login" do
    get new_plan_path
    assert_redirected_to login_path
    follow_redirect!
    assert_template 'sessions/new'
    assert_not flash.empty?
  end

  test "create should success with valid infomation" do
    log_in_as(@user)
    get new_plan_path
    assert_template 'plans/new'
    assert_difference 'Plan.count', 1 do
      post plans_path, params: { plan: {title: 'Test title',
                                        content: 'Test content'}}
    end
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end

  test "create should fail with invalid infomation" do
    log_in_as(@user)
    get new_plan_path
    assert_template 'plans/new'
    assert_no_difference 'Plan.count' do
      post plans_path, params: { plan: {title: '  ',
                                        content: '  '}}
    end
    assert_template 'plans/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end
end
