require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select '.user_name', text: 'Account name : ' + @user.name
    assert_match @user.plans.count.to_s, response.body
    assert_select 'div.pagination'
    @user.plans.paginate(page: 1).each do |plan|
      assert_match plan.content, response.body
    end
  end
end
