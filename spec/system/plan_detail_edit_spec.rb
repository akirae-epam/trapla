# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
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
  # 削除ボタンを押したら削除できる
  # 編集フォーム：カレンダーボタンを押したらカレンダーから日時選択できる
  # 編集フォーム：アクションボタンを押したらチェック状態になりほかはチェック外される
  # 編集フォーム：持ち物を入力したら持ち物リストに追加される
  # 編集フォーム：費用項目にカンマは入力できない
  # 編集フォーム：費用金額に数字以外は入力できない
  # 編集フォーム：費用追加ボタンで金額が追加され、合計金額に反映される
  # 編集フォーム：費用削除ボタンで金額が削除され、合計金額に反映される
end
