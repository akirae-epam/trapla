# frozen_string_literal: true

require 'test_helper'

class PlansControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @plan = plans(:one)
  end

  # ログインしていないとPlan作成できない
  test 'should redirect create when not logged in' do
    assert_no_difference 'Plan.count' do
      post plans_path, params: { Plan: { title: 'title test', content: 'content test' } }
    end
    assert_redirected_to login_url
  end

  # ログインしていないとPlan削除できない
  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Plan.count' do
      delete plan_path(@plan)
    end
    assert_redirected_to login_url
  end

  # ログインしていないとPlanみれない
  test 'plan show should failed without login' do
    get plans_path
    assert_redirected_to login_path
    follow_redirect!
    assert_template 'sessions/new'
    assert_not flash.empty?
  end

  # ログインしたらPlanみれる
  test 'plan show should success with login' do
    log_in_as(@user)
    get plans_path
    assert_template 'plans/index'
    assert_select 'a[href=?]', plan_path(@plan)
  end

  test 'plan index should success with login' do
    log_in_as(@user)
    get plan_path(@plan)
    assert_template 'plans/show'
  end

end
