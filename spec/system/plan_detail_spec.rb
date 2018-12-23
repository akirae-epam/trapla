# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    @user = User.create(name: 'testuser',
                        email: 'test@email.com',
                        password: 'foobar',
                        password_confirmation: 'foobar',
                        activated: true)
    @plan = Plan.create(title: 'test plan title',
                        content: 'test plan content',
                        user: @user)

    # ログインする
    visit login_path
    fill_in 'session[email]', with: 'test@email.com'
    fill_in 'session[password]', with: 'foobar'
    click_button 'ログイン'
    uri = URI.parse(current_url)
    expect(uri.path).to eq user_path(@user)
  end

  it 'create new plan_detail' do
    visit edit_plan_path(@plan)
    expect(page).to have_field 'plan[title]', with: @plan.title
    expect(page).to have_field 'plan[content]', with: @plan.content

    find('#add-plan-detail-button').click
    expect(page).to have_content 'アクティビティの追加'

    # 日付入力
    page.execute_script("$('#plan_detail_date').val('2018/01/01 12:00')")
    fill_in 'plan_detail[place]', with: 'Plan Detail Place Test'

    # アクション選択
    choose '集合'

    # アクションメモ入力
    fill_in 'plan_detail[action_memo]', with: 'Plan Detail Action Memo Test'

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
  end
end
