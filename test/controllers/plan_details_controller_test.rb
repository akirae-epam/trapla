# frozen_string_literal: true

require 'test_helper'

class PlanDetailsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @plan = plans(:one)
  end

  # ログインしたらPlanDetail作成できる
  # ログインしていないとPlanDetail作成できない
  # ログインしていないとPlanDetail削除できない
  # 自分のPlanDetailしか編集できない
  # 自分のPlanDetailしか削除できない

end
