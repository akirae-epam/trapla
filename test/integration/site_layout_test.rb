# frozen_string_literal: true

require 'test_helper'
class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @plan = plans(:one)
    @plan_detail = plan_details(:first)
  end

  test 'static_pages/home: layout links' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 1
    assert_select 'a[href=?]', signup_path, count: 2
    assert_select 'a[href=?]', login_path, count: 2
  end

  test 'plans/show: year should appear only once' do
    log_in_as(@user)
    get plan_path(@plan)
    assert_template 'plans/show'
    assert_select '.draw-year',
                  text: @plan_detail.date.strftime('%Y'),
                  count: 1
  end

  test 'plans/show: day should appear only once' do
    log_in_as(@user)
    get plan_path(@plan)
    assert_template 'plans/show'
    assert_select '.draw-day',
                  text: @plan_detail.date.strftime('%m/%d'),
                  count: 1
  end
end
