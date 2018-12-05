# frozen_string_literal: true

module PlanDetailsHelper

  def drow_date(plan_detail, format)
    current_date = plan_detail.date.strftime(format)
    if @remember_date
      prev_date = @remember_date[format.to_sym] if @remember_date[:format]
      return plan_detail.date.strftime(format) if current_date != prev_date
      @remember_date = {format: plan_detail.date.strftime(format)}
    else
      prev_date = @remember_date = {format: plan_detail.date.strftime(format)}
    end
  end

end
