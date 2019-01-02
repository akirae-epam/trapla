# frozen_string_literal: true

require 'test_helper'

class PlanDetailsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @plan_detail = plan_details(:first)
    @plan = @plan_detail.plan
    @user = @plan.user
    @other_plan_detail = plan_details(:other_plan_detail)
    @other_plan = @other_plan_detail.plan
    @other = @other_plan.user
    @valid_date = Time.zone.now
  end

  # ログインしていないとPlanDetail作成できない
  test 'create detail should redirect login when not logged in' do
    assert_no_difference 'PlanDetail.count' do
      post plans_path, params: { Plan: { date: Time.zone.now,
                                         place: 'valid place',
                                         action_type: 'set',
                                         action_memo: 'test memo',
                                         belongings: "test1\ntest2",
                                         payments_items: 'test1,test2',
                                         payments_moneys: '100,200' } }
    end
    assert_redirected_to login_url
  end

  # ログインしていないとPlanDetail削除できない
  test 'destroy detail should redirect destroy when not logged in' do
    assert_no_difference 'PlanDetail.count' do
      delete plan_path(@plan_detail)
    end
    assert_redirected_to login_url
  end

  # ログインしても他人のPlanDetailは作成できない
  test 'Plan_detail owned by another create should fail' do
    log_in_as(@user)
    assert_no_difference 'PlanDetail.count' do
      post plan_details_path, params: { plan_id: @other_plan.id,
                                        plan_detail: {
                                          date: @valid_date,
                                          place: 'valid place',
                                          action_type: 'walk',
                                          action_memo: 'valid memo'
                                        } }
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
                                          date: @valid_date,
                                          place: 'valid place',
                                          action_type: 'walk',
                                          action_memo: 'valid memo'
                                        } }
    end
    assert_redirected_to edit_plan_path(@plan)
  end
end
