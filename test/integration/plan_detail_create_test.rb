# frozen_string_literal: true.

require 'test_helper'

class PlanDetailCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @plan = @user.plans.first
    @other_user = users(:archer)
    @other_plan = @other_user.plans.first
  end

  # ログインしていないとPlanDetail作成できない
  test 'Plan_detail create should failed without login' do
    assert_no_difference 'PlanDetail.count' do
      post plan_details_path, params: { plan_id: @plan.id,
                                        plan_detail: {
                                          date: Time.zone.now,
                                          place: 'valid place',
                                          action_type: 'walk',
                                          action_memo: 'valid memo' } }
    end
  end

  # ログインしても他人のPlanDetailは作成できない
  test 'Plan_detail owned by another create should success with login' do
    log_in_as(@user)
    assert_no_difference 'PlanDetail.count' do
      post plan_details_path, params: { plan_id: @other_plan.id,
                                        plan_detail: {
                                          date: Time.zone.now,
                                          place: 'valid place',
                                          action_type: 'walk',
                                          action_memo: 'valid memo' } }
    end
    assert_redirected_to root_url
  end

  # ログインしたら自分のPlanDetailが作成できる
  test 'Plan_detail create should success with login' do
    log_in_as(@user)
    get edit_plan_path(@plan)
    assert_template 'plans/edit'
    assert_difference 'PlanDetail.count', 1 do
      post plan_details_path, params: { plan_id: @plan.id,
                                        plan_detail: {
                                          date: Time.zone.now,
                                          place: 'valid place',
                                          action_type: 'walk',
                                          action_memo: 'valid memo' } }
    end
    assert_redirected_to edit_plan_path(@plan)
  end

  # ログインしたら自分のPlanDetailが作成できる(ajax)
  test 'Plan_detail create should success with login (ajax)' do
    log_in_as(@user)
    get edit_plan_path(@plan)
    assert_template 'plans/edit'
    assert_difference 'PlanDetail.count', 1 do
      post plan_details_path, xhr: true, params: {
                                           plan_id: @plan.id,
                                           plan_detail: {
                                             date: Time.zone.now,
                                             place: 'valid place',
                                             action_type: 'walk',
                                             action_memo: 'valid memo' } }
    end
    assert_template 'plan_details/_each_plan_detail'
  end

  # PlanDetail作成したら画面に追加される
  test 'Plan_detail should count up after create' do
    log_in_as(@user)
    assert_select '.plan_detail', count:@plan.plan_details.count
    post plan_details_path, params: { plan_id: @plan.id,
                                      plan_detail: {
                                        date: Time.zone.now,
                                        place: 'valid place',
                                        action_type: 'walk',
                                        action_memo: 'valid memo' } }
    assert_redirected_to edit_plan_path(@plan)
    follow_redirect!
    assert_select '.plan_detail', count:@plan.plan_details.count
  end

  # 自分のPlanDetailしか編集できない
  # ログインしていないとPlanDetail削除できない
  # 自分のPlanDetailしか削除できない
end
