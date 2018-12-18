# frozen_string_literal: true

require 'test_helper'

class PlanCopyTest < ActionDispatch::IntegrationTest
  def setup
    @plan_detail = plan_details(:first)
    @plan = @plan_detail.plan
    @user = @plan.user
    @blank_plan = plans(:blank_plan)
  end

  test 'plan should not be copied without login' do
    assert_no_difference 'PlanDetail.count' do
      get copy_plan_path(@plan)
    end
    assert_redirected_to login_path
  end

  test 'plan should be copied with login' do
    log_in_as(@user)
    assert_difference 'Plan.count', 1 do
      get copy_plan_path(@plan)
    end
    @copied_plan = assigns(:plan)
    assert_redirected_to edit_plan_path(@copied_plan)
  end

  test 'blank plan should be copied with login' do
    log_in_as(@user)
    assert_difference 'Plan.count', 1 do
      get copy_plan_path(@blank_plan)
    end
    @copied_plan = assigns(:plan)
    assert_redirected_to edit_plan_path(@copied_plan)
  end

  test 'plan_details should be copied' do
    log_in_as(@user)
    assert_difference 'PlanDetail.count', @plan.plan_details.count do
      get copy_plan_path(@plan)
    end
    @copied_plan = assigns(:plan)
    assert_equal @plan.plan_details.count, @copied_plan.plan_details.count
    assert_equal @plan.plan_details.first.date, @copied_plan.plan_details.first.date
    assert_equal @plan.plan_details.last.date, @copied_plan.plan_details.last.date
  end

  test 'base plan should not be changed after copied' do
    log_in_as(@user)
    before_plan = @plan
    get copy_plan_path(@plan)
    assert_equal before_plan.title, @plan.reload.title
    assert_equal before_plan.content, @plan.reload.content
    assert_equal before_plan.plan_details.first.date, @plan.plan_details.first.date
    assert_equal before_plan.plan_details.last.date, @plan.plan_details.last.date
  end
end
