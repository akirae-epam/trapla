# frozen_string_literal: true

require 'test_helper'

class PlanDetailTest < ActiveSupport::TestCase
  def setup
    @valid_date = Time.zone.now
    @valid_place = 'valid place'
    @valid_action_type = 'car'
    @valid_action_memo = 'valid memo'
    @user = users(:michael)
    @plan = @user.plans.create(title: 'Title test', content: 'content test')
    @plan_detail = PlanDetail.new(date: @valid_date,
                                  place: @valid_place,
                                  action_type: @valid_action_type,
                                  action_memo: @valid_action_memo,
                                  plan: @plan)
  end

  test 'date should be valid with correct format' do
    assert @plan_detail.valid?
    assert @plan_detail.errors.messages.empty?
  end

  test 'date should not be blank' do
    @plan_detail.date = ''
    assert_not @plan_detail.valid?
    assert_not @plan_detail.errors.messages[:date].empty?
  end

  test 'plan id should be present' do
    @plan_detail.plan = nil
    assert_not @plan_detail.valid?
    assert_not @plan_detail.errors.messages[:plan].empty?
  end

  test 'place should be present' do
    @plan_detail.place = ''
    assert_not @plan_detail.valid?
    assert_not @plan_detail.errors.messages[:place].empty?
  end

  test 'place should be at most 50 characters' do
    @plan_detail.place = 'a' * 51
    assert_not @plan_detail.valid?
  end

  test 'plan_detail deleted when parent plan deleted' do
    @plan_detail.save
    plan_detail_count = 0 - @plan.plan_details.count
    assert_difference 'PlanDetail.count', plan_detail_count do
      @plan.destroy
    end
  end
end
