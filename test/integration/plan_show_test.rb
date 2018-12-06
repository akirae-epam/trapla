# frozen_string_literal: true

require 'test_helper'

class PlanShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @plan = plans(:one)
    @plan_detail = plan_details(:first)
  end

  test 'year should appear only once' do
    log_in_as(@user)
    get plan_path(@plan)
    assert_template 'plans/show'
    assert_select '.plan_detail_date > h2',
                  text: @plan_detail.date.strftime('%Y'),
                  count: 1
  end

  test 'day should appear only once' do
    log_in_as(@user)
    get plan_path(@plan)
    assert_template 'plans/show'
    assert_select '.plan_detail_date > h3',
                  text: @plan_detail.date.strftime('%m/%d'),
                  count: 1
  end
end
