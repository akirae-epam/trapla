# frozen_string_literal: true

module PlanDetailsHelper

  # 一個前のアクティビティと日付が変わっていたら日付を描写
  def drow_date(plan_detail, format)
    plan = plan_detail.plan

    # formatに応じて現在の日時、一個前の日時を取得
    current_date = plan_detail.date.strftime('%Y') if format == 'year'
    current_date = plan_detail.date.strftime('%m/%d') if format == 'day'
    prev_date = plan.remember_year if format == 'year' && plan.remember_year
    prev_date = plan.remember_day if format == 'day' && plan.remember_day

    # 一個前と違う日時であれば現在の日時を返す
    if prev_date != current_date
      plan.remember_date(current_date, format)
      return current_date
    else return ''
    end
  end

end
