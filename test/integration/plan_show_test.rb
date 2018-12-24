# frozen_string_literal: true

require 'test_helper'

class PlanShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @plan = plans(:one)
    @other_user = users(:archer)
    @other_plan = plans(:archer_plan_0)
  end

  test 'plan show should success even if without login' do
    get plan_path(@plan)
    assert_template 'plans/show'
    assert flash.empty?
    get plan_path(@other_plan)
    assert_template 'plans/show'
    assert flash.empty?
  end

  test 'plan show should success with login' do
    log_in_as(@user)
    get plan_path(@plan)
    assert_template 'plans/show'
    assert flash.empty?
    get plan_path(@other_plan)
    assert_template 'plans/show'
    assert flash.empty?
  end
end
