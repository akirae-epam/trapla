# frozen_string_literal: true

module PlanDetailsHelper
  # 一個前のアクティビティと日付が変わっていたら日付を描写
  def drow_date(plan_detail, format)
    plan = plan_detail.plan

    # formatに応じて現在の日時、一個前の日時を取得
    case format
    when 'year'
      current_date = plan_detail.date.strftime('%Y')
      prev_date = plan.remember_year if plan.remember_year
    when 'day'
      current_date = plan_detail.date.strftime('%m/%d')
      prev_date = plan.remember_day if plan.remember_day
    end

    # 一個前と違う日時であれば現在の日時を返す
    return '' unless prev_date != current_date

    plan.remember_date(current_date, format)
    return current_date
  end
end
