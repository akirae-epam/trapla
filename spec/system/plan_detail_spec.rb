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

  it 'create new plan and plan_detail' do
    # 新規プラン作成ページでプラン作成
    visit new_plan_path

    fill_in 'plan[title]', with: 'Plan Title Test'
    fill_in 'plan[content]', with: 'Plan Content Test'

    click_button 'プランを作成する'

    # 新規アクティビティ作成
    expect(page).to have_content 'プランを作成しました。'

  end

  it 'add plan_detail' do
    visit edit_plan_path(@plan)
    expect(page).to have_field 'plan[title]', with: @plan.title
    expect(page).to have_field 'plan[content]', with: @plan.content

    find('#add-plan-detail-button').click
    expect(page).to have_content 'アクティビティの追加'

    page.execute_script("$('#plan_detail_date').val('2018/01/01 12:00')")
    fill_in 'plan_detail[place]', with: 'Plan Detail Place Test'

    choose 'plan_detail_action_type_set' # 選ぶのは何でもいい
    fill_in 'plan_detail[action_memo]', with: 'Plan Detail Action Memo Test'

    # 持ち物入力
    fill_in 'plan_detail[belongings]',
            with: "Plan Detail Belonging Test1\nPlan Detail Belonging Test2"

  end
end
