# frozen_string_literal: true

require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @plan = @user.plans.build(title: 'Title test', content: 'Lorem ipsum')
  end

  test 'should be valid' do
    assert @plan.valid?
  end

  test 'user_id should be present' do
    @plan.user = nil
    assert_not @plan.valid?
  end

  test 'title should not be blank' do
    @plan.title = '  '
    assert_not @plan.valid?
  end

  test 'content should be at most 140 characters' do
    @plan.content = 'a' * 141
    assert_not @plan.valid?
  end

  test 'order should be most recent first' do
    assert_equal plans(:most_recent), Plan.first
  end

  test 'plan deleted when parent user deleted' do
    @plan.save
    plan_count = 0 - @user.plans.count
    assert_difference 'Plan.count', plan_count do
      @user.destroy
    end
  end
end
