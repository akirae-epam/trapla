# frozen_string_literal: true

require 'test_helper'

class PlanSearchTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  # プラン検索
  test 'seach plans' do
    log_in_as(@user)
    get root_path

    assert_template 'static_pages/home'
    assert_select '.plan-list', minimum: 3

    post search_plans_path, params: { keyword: 'search test' }
    assert_select '.plan-list', count: assigns(:plans).count
  end
end
