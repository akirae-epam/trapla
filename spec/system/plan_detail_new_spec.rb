# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :feature, js: true do
  before do
    @plan_detail = create(:main_plan_detail)
    @plan = @plan_detail.plan
    @user = @plan.user

    # ログインする
    visit login_path
    fill_in 'session[email]', with: 'spec_test@email.com'
    fill_in 'session[password]', with: 'foobar'
    click_button 'ログイン'
    expect(current_path).to eq user_path(@user)
  end

  # 新規アクティビティの追加
  it 'create new plan_detail' do
    visit edit_plan_path(@plan)
    expect(page).to have_field 'plan[title]', with: @plan.title
    expect(page).to have_field 'plan[content]', with: @plan.content

    find('#add-plan-detail-button').click
    expect(page).to have_content 'アクティビティの追加'

    # 日付入力
    page.execute_script("$('#plan_detail_date').val('2018/01/01 13:00')")
    fill_in 'plan_detail[place]', with: 'Plan Detail Place Test2'

    # アクション選択
    execute_script('window.scrollBy(0,10000)') # スクロールさせる
    find_by_id('label_walk').click

    # アクションメモ入力
    fill_in 'plan_detail[action_memo]', with: 'Plan Detail Action Memo Test2'

    # 持ち物入力
    fill_in 'plan_detail[belongings]',
            with: "Plan Detail Belonging Test1\nPlan Detail Belonging Test2"

    # 費用入力
    5.times do |n|
      fill_in 'plan_detail_payment[item]', with: "payment#{n}"
      fill_in 'plan_detail_payment[money]', with: '1000'
      find('.payment-button > p ').click
      expect(page).to have_content "payment#{n}"
    end
    # 合計値が表示されている
    expect(page).to have_content '¥5,000'

    # アクティビティ作成
    click_button 'アクティビティを保存する'

    expect(page).to have_content 'Plan Detail Place Test2'
    expect(page).to have_content 'Plan Detail Action Memo Test2'
    expect(page).to have_content('2018', count: 1)
    expect(page).to have_content('01/01', count: 1)
    expect(page).to have_content '13:00'
    expect(page).to have_content '徒歩'
  end

  # 不正な値では作成できない
  it 'create new plan_detail' do
    visit edit_plan_path(@plan)
    find('#add-plan-detail-button').click
    expect(page).to have_content 'アクティビティの追加'

    page.execute_script("$('#plan_detail_date').val('')")
    fill_in 'plan_detail[place]', with: ''

    click_button 'アクティビティを保存する'
    expect(page).to have_content 'アクティビティの追加'

    execute_script('window.scrollBy(0,-5000)') # スクロールさせる
    expect(page).to have_content 'The form contains 2 errors.'
  end
end
