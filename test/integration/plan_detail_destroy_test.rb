# frozen_string_literal: true

require 'test_helper'

class PlanDetailDestroyTest < ActionDispatch::IntegrationTest
  def setup
    @plan_detail = plan_details(:first)
    @plan = @plan_detail.plan
    @user = @plan.user
    @other_plan_detail = plan_details(:other_plan_detail)
    @other_plan = @other_plan_detail.plan
    @other_user = @other_plan.user
  end

  # ログインしていないとPlanDetail削除できない
  test 'Plan_detail delete should failed without login' do
    assert_no_difference 'PlanDetail.count' do
      delete plan_detail_path(@plan_detail, plan_id: @plan_detail.plan.id)
    end
    assert_redirected_to login_path
  end

  # ログインしても他人のPlanDetailは削除できない
  test 'Plan_detail owned by another delete should fail' do
    log_in_as(@user)
    assert_no_difference 'PlanDetail.count' do
      delete plan_detail_path(@other_plan_detail, plan_id: @other_plan_detail.plan.id)
    end
    assert_redirected_to root_url
  end

  # ログインしたら自分のPlanDetailが削除できる
  test 'Plan_detail delete should success with login' do
    log_in_as(@user)
    get edit_plan_path(@plan)
    assert_template 'plans/edit'
    assert_difference 'PlanDetail.count', -1 do
      delete plan_detail_path(@plan_detail, plan_id: @plan_detail.plan.id)
    end
    assert_redirected_to edit_plan_path(@plan)
  end

  # ログインしたら自分のPlanDetailが作成できる(ajax)
  test 'Plan_detail delete should success with login (ajax)' do
    log_in_as(@user)
    get edit_plan_path(@plan)
    assert_template 'plans/edit'
    assert_difference 'PlanDetail.count', -1 do
      delete plan_detail_path(@plan_detail, plan_id: @plan_detail.plan.id)
    end
  end

  # PlanDetail削除したら画面から消える
  test 'Plan_detail should count down after delete' do
    log_in_as(@user)
    get edit_plan_path(@plan)
    assert_template 'plans/edit'
    assert_select '.plan_detail', count: @plan.plan_details.count
    delete plan_detail_path(@plan_detail, plan_id: @plan_detail.plan.id)
    assert_redirected_to edit_plan_path(@plan)
    follow_redirect!
    assert_select '.plan_detail', count: @plan.plan_details.reload.count
  end
end
