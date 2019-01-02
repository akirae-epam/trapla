# frozen_string_literal: true

require 'test_helper'

class PlansControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @plan = plans(:one)
  end

  # ログインしていないとPlan作成できない
  test 'create should redirect login when not logged in' do
    assert_no_difference 'Plan.count' do
      post plans_path, params: { Plan: { title: 'title test',
                                         content: 'content test' } }
    end
    assert_redirected_to login_url
  end

  # ログインしていないとPlan削除できない
  test 'destroy hould redirect login when not logged in' do
    assert_no_difference 'Plan.count' do
      delete plan_path(@plan)
    end
    assert_redirected_to login_url
  end
end
