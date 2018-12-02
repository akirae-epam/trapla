# frozen_string_literal: true

require 'test_helper'

class PlanEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @plan = plans(:one)
  end

  test 'edit should failed without login' do
    get edit_plan_path(@plan)
    assert_redirected_to login_path
    follow_redirect!
    assert_template 'sessions/new'
    assert_not flash.empty?
  end

  test 'edit should failed with invalid user' do
    log_in_as(@other_user)
    get edit_plan_path(@plan)
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
    assert flash.empty?
  end

  test 'edit should success with valid infomation' do
    log_in_as(@user)
    get edit_plan_path(@plan)
    assert_template 'plans/edit'
    patch plan_path(@plan), params: { plan: { title: 'Test title edit',
                                              content: 'Test content edit' } }
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end

  test 'edit should fail with invalid infomation' do
    log_in_as(@user)
    get edit_plan_path(@plan)
    assert_template 'plans/edit'
    patch plan_path(@plan), params: { plan: { title: '   ',
                                              content: '   ' } }
    assert_template 'plans/edit'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end
end
