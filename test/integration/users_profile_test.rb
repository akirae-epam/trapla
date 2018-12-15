# frozen_string_literal: true

require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test 'profile display' do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_match @user.plans.count.to_s, response.body
    assert_select 'div.pagination'
    @user.plans.paginate(page: 1).each do |plan|
      assert_match plan.content, response.body
    end
  end

  test 'profile display plan edit links' do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'a', text: 'このプランを編集する'
  end

  test 'profile should not display another plan edit links' do
    log_in_as(@user)
    get user_path(@other_user)
    assert_template 'users/show'
    assert_select 'a', text: 'このプランを編集する', count: 0
  end
end
