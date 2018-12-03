# frozen_string_literal: true

require 'test_helper'
class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'layout links' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 1
    assert_select 'a[href=?]', signup_path, count: 2
    assert_select 'a[href=?]', login_path, count: 2
  end
end
