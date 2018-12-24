# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    @plan_detail = FactoryBot.create(:main_plan_detail)
    @plan = @plan_detail.plan
    @user = @plan.user

    # ログインする
    visit login_path
    fill_in 'session[email]', with: 'spec_test@email.com'
    fill_in 'session[password]', with: 'foobar'
    click_button 'ログイン'
    uri = URI.parse(current_url)
    expect(uri.path).to eq user_path(@user)
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
    choose '徒歩'

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
    expect(page).to have_content '01/01'
    expect(page).to have_content '13:00'
    expect(page).to have_content '徒歩'
  end

  # マウスを乗せたら編集メニューが出てくる
  it 'edit plan detail view visible after click button' do
    visit edit_plan_path(@plan)
    expect(page).to have_css('.plan-detail-edit > a > img', count: 0)
    find("#plan_detail_#{@plan_detail.id}").hover
    expect(page).to have_css('.plan-detail-edit > a > img', count: 2)
  end

  # 編集ボタンを押したら編集フォームが出てくる
  # 削除ボタンを押したら削除できる
  # 編集フォーム：カレンダーボタンを押したらカレンダーから日時選択できる
  # 編集フォーム：アクションボタンを押したらチェック状態になりほかはチェック外される
  # 編集フォーム：持ち物を入力したら持ち物リストに追加される
  # 編集フォーム：費用項目にカンマは入力できない
  # 編集フォーム：費用金額に数字以外は入力できない
  # 編集フォーム：費用追加ボタンで金額が追加され、合計金額に反映される
  # 編集フォーム：費用削除ボタンで金額が削除され、合計金額に反映される
end
