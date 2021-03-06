# frozen_string_literal: true

require 'test_helper'

class PlanDetailCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @plan = plans(:one)
    @other_user = users(:archer)
    @other_plan = plans(:archer_plan)
    @valid_date = Time.zone.now
  end

  # PlanDetail作成したら画面に追加される
  test 'Plan_detail should count up after create' do
    log_in_as(@user)
    get edit_plan_path(@plan)
    assert_select '.plan-detail', count: @plan.plan_details.count
    post plan_details_path, params: { plan_id: @plan.id,
                                      plan_detail: {
                                        date: @valid_date,
                                        place: 'valid place',
                                        action_type: 'walk',
                                        action_memo: 'valid memo'
                                      } }
    assert_redirected_to edit_plan_path(@plan)
    follow_redirect!
    assert_select '.plan-detail', count: @plan.plan_details.count
  end

  # 自分のPlanDetailしか編集できない
  # ログインしていないとPlanDetail削除できない
  # 自分のPlanDetailしか削除できない
end
