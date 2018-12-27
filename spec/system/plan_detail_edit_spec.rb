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
    uri = URI.parse(current_url)
    expect(uri.path).to eq user_path(@user)
  end

  # マウスを乗せたら編集メニューが出てくる
  it 'edit plan detail view visible after click button' do
    visit edit_plan_path(@plan)
    expect(page).to have_css('.plan-detail-edit > a > img', count: 0)
    find("#plan_detail_#{@plan_detail.id}").hover
    expect(page).to have_css('.plan-detail-edit > a > img', count: 2)
  end

  # 編集ボタンを押したら編集フォームが出てくる
  it 'edit plan detail view visible after click button' do
    visit edit_plan_path(@plan)
    find("#plan_detail_#{@plan_detail.id}").hover
    expect(page).to have_css('.edit-plan-detail > form', count: 0)
    find('.to-plan-detail-edit').click
    expect(page).to have_css('.edit-plan-detail > form', count: 1)
    find('.to-plan-detail-edit').click
    expect(page).to have_css('.edit-plan-detail > form', count: 0)
  end

  # 削除ボタンを押したら削除できる
  it 'edit plan detail delete should success' do
    visit edit_plan_path(@plan)

    expect(page).to have_content @plan.title
    expect(page).to have_content @plan.content
    expect(page).to have_content(@plan_detail.date.strftime('%Y'), count: 1)
    expect(page).to have_content @plan_detail.date.strftime('%m/%d')
    expect(page).to have_content @plan_detail.date.strftime('%H:%M')
    expect(page).to have_content '集合'

    find("#plan_detail_#{@plan_detail.id}").hover
    expect(page).to have_css('.edit-plan-detail > form', count: 0)
    find('.to-plan-detail-delete').click

    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content(@plan.title, count: 1)
    expect(page).to have_content(@plan.content, count: 1)
    expect(page).to have_content(@plan_detail.date.strftime('%Y'), count: 0)
    expect(page).to have_content(@plan_detail.date.strftime('%m/%d'), count: 0)
    expect(page).to have_content(@plan_detail.date.strftime('%H:%M'), count: 0)
    expect(page).to have_content('集合', count: 0)
  end

  # 編集フォーム：カレンダーボタンを押したらカレンダーから日時選択できる
  it 'edit plan detail view visible after click button' do
    visit edit_plan_path(@plan)
    take_screenshot
    find("#plan_detail_#{@plan_detail.id}").hover
    take_screenshot
    find('.to-plan-detail-edit', wait: 5).click
    take_screenshot

    expect(page).to have_field '日付と時間', with: @plan_detail.date.strftime('%Y/%m/%d %H:%M')

  end

  # 編集フォーム：アクションボタンを押したらチェック状態になりほかはチェック外される
  # 編集フォーム：持ち物を入力したら持ち物リストに追加される
  # 編集フォーム：費用項目にカンマは入力できない
  # 編集フォーム：費用金額に数字以外は入力できない
  # 編集フォーム：費用追加ボタンで金額が追加され、合計金額に反映される
  # 編集フォーム：費用削除ボタンで金額が削除され、合計金額に反映される
end
