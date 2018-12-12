# frozen_string_literal: true

module PlanDetailsHelper
  # 一個前のアクティビティと日付が変わっていたら日付を描写
  def draw_date(plan_detail, format)
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

  def draw_action(key)
    return @action_type_move[key.to_sym] unless @action_type_move[key.to_sym].nil?
    return @action_type_visit [key.to_sym] unless @action_type_visit [key.to_sym].nil?
  end

  def draw_belongings(belongings)
    value = belongings.split(/\r\n|\r|\n/)
    output = ''
    value.each do |n|
      output += "<li>#{n}</li>"
    end
    return output.html_safe
  end
end
