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
  it 'edit plan detail view visible after mouse on button' do
    visit edit_plan_path(@plan)
    expect(page).to have_no_css('.plan-detail-edit > a > img')
    find("#plan_detail_#{@plan_detail.id}").hover
    expect(page).to have_css('.plan-detail-edit > a > img', count: 2)
  end

  # 編集ボタンを押したら編集フォームが出てくる
  it 'edit plan detail view visible after click button' do
    visit edit_plan_path(@plan)
    find("#plan_detail_#{@plan_detail.id}").hover
    expect(page).to have_no_css('.edit-plan-detail > form')
    find('.to-plan-detail-edit').click
    expect(page).to have_css('.edit-plan-detail > form', count: 1)

    # もう一度クリックすると消える
    find('.to-plan-detail-edit').click
    expect(page).to have_no_css('.edit-plan-detail > form')
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
    expect(page).to have_no_css('.edit-plan-detail > form')
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
  it 'datepicker should visible after calender button' do
    visit edit_plan_path(@plan)
    find("#plan_detail_#{@plan_detail.id}").hover
    find('.to-plan-detail-edit').click
    expect(find('#plan_detail_date').value).to eq @plan_detail.date.strftime('%Y/%m/%d %H:%M')
    find('.input-group-addon').click
    expect(page).to have_content('Su', count: 1)
    expect(page).to have_content('Mo', count: 1)
    expect(page).to have_content('Tu', count: 1)
    expect(page).to have_content('We', count: 1)
    expect(page).to have_content('Th', count: 1)
    expect(page).to have_content('Fr', count: 1)
    expect(page).to have_content('Sa', count: 1)

    # もう一度クリックすると消える
    find('.input-group-addon').click
    expect(page).to have_content('Su', count: 0)
    expect(page).to have_content('Mo', count: 0)
    expect(page).to have_content('Tu', count: 0)
    expect(page).to have_content('We', count: 0)
    expect(page).to have_content('Th', count: 0)
    expect(page).to have_content('Fr', count: 0)
    expect(page).to have_content('Sa', count: 0)
  end

  # 編集フォーム：アクションボタンを押したらチェック状態になりほかはチェック外される
  it 'check only on active class' do
    visit edit_plan_path(@plan)
    find("#plan_detail_#{@plan_detail.id}").hover
    find('.to-plan-detail-edit').click
    # アクション選択した前後でactiveの数が変わらない
    expect(page).to have_css('.active', count: 1)
    execute_script('window.scrollBy(0,10000)') # スクロールさせる
    find_by_id('label_walk').click
    expect(page).to have_css('.active', count: 1)
  end

  # 編集フォーム：持ち物を入力したら持ち物リストに追加される
  it 'add belongings' do
    visit edit_plan_path(@plan)
    find("#plan_detail_#{@plan_detail.id}").hover
    find('.to-plan-detail-edit').click

    execute_script('window.scrollBy(0,10000)') # スクロールさせる
    3.times do |n|
      expect(find('#output_belongings')).to have_content "belongings_test#{n + 1}", count: 0
    end
    fill_in 'plan_detail[belongings]', with: "belongings_test1\nbelongings_test2\nbelongings_test3"
    3.times do |n|
      expect(find('#output_belongings')).to have_content "belongings_test#{n + 1}", count: 1
    end
  end

  # 編集フォーム：費用項目にカンマは入力できない
  it '"," should not inputable in payment item' do
    visit edit_plan_path(@plan)
    find("#plan_detail_#{@plan_detail.id}").hover
    find('.to-plan-detail-edit').click

    execute_script('window.scrollBy(0,10000)') # スクロールさせる
    expect(find('#plan_detail_payment_item').value).to eq ''
    fill_in 'plan_detail_payment[item]', with: 'item,test'
    expect(find('#plan_detail_payment_item').value).to eq 'itemtest'
  end

  # 編集フォーム：費用金額に数字以外は入力できない
  it 'except number should not inputable in payment money' do
    visit edit_plan_path(@plan)
    find("#plan_detail_#{@plan_detail.id}").hover
    find('.to-plan-detail-edit').click

    execute_script('window.scrollBy(0,10000)') # スクロールさせる
    expect(find('#plan_detail_payment_money').value).to eq ''
    fill_in 'plan_detail_payment[money]', with: 'moneytest1000,moneytest'
    expect(find('#plan_detail_payment_money').value).to eq '1000'
  end

  # 編集フォーム：費用追加ボタンで金額が追加され、合計金額に反映される
  it 'money sum should output' do
    visit edit_plan_path(@plan)
    find("#plan_detail_#{@plan_detail.id}").hover
    find('.to-plan-detail-edit').click

    execute_script('window.scrollBy(0,10000)') # スクロールさせる

    # plan_detailの金額の合計を算出
    moneys = @plan_detail.payments_moneys.split(',').map(&:to_i).sum
    money_yen = num_to_jpyen(moneys)
    expect(find('#payments_output_total')).to have_content "合計：#{money_yen}", count: 1

    # 入力予定の項目と金額がまだ入力されていないこと
    expect(find('#payments_output_item')).to have_content 'itemtest', count: 0
    expect(find('#payments_output_money')).to have_content '¥12,345,678', count: 0

    # 項目と金額を入力
    fill_in 'plan_detail_payment[item]', with: 'itemtest'
    fill_in 'plan_detail_payment[money]', with: '12345678'

    # 追加ボタンをクリックしたら入力金額が反映される
    find('.payment-button').click
    expect(find('#payments_output_item')).to have_content 'itemtest'
    expect(find('#payments_output_money')).to have_content '¥12,345,678'

    # 合計値にも反映される
    moneys += 12_345_678 # 合計値を算出
    money_yen = num_to_jpyen(moneys)
    expect(find('#payments_output_total')).to have_content "合計：#{money_yen}", count: 1
  end

  # 編集フォーム：費用削除ボタンで金額が削除され、合計金額に反映される
  it 'money sum should delete' do
    visit edit_plan_path(@plan)
    find("#plan_detail_#{@plan_detail.id}").hover
    find('.to-plan-detail-edit').click

    execute_script('window.scrollBy(0,30000)') # スクロールさせる

    # plan_detailの金額の合計を算出
    moneys = @plan_detail.payments_moneys.split(',').map(&:to_i).sum
    money_yen = num_to_jpyen(moneys)
    expect(find('#payments_output_total')).to have_content "合計：#{money_yen}", count: 1

    # 金額削除ボタンをクリックしたら入力金額が削除される
    items = @plan_detail.payments_items.split(',')
    moneys = @plan_detail.payments_moneys.split(',').map(&:to_i)
    money_sum = moneys.sum

    items.length.times do |n|
      money_yen = num_to_jpyen(moneys[n])
      expect(find("#plan_detail_payments_item_#{n}")).to have_content items[n], count: 1
      expect(find("#plan_detail_payments_money_#{n}")).to have_content money_yen, count: 1

      # 削除ボタンを押下
      find("#plan_detail_payments_money_#{n} > .delete-money").click
      expect(page).to have_no_css("#plan_detail_payments_item_#{n}")
      expect(page).to have_no_css("#plan_detail_payments_money_#{n}")

      # 合計値にも反映される
      money_sum -= moneys[n]
      money_yen = num_to_jpyen(money_sum)
      expect(find('#payments_output_total')).to have_content "合計：#{money_yen}", count: 1
    end
  end
end
