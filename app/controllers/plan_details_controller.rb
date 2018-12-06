# frozen_string_literal: true

class PlanDetailsController < ApplicationController
  before_action :logged_in_user

  def show; end

  def create; end

  def update; end

  def destroy; end

  private

  def plan_detail_params
    params.require(:plan_detail).permit(:date,
                                        :place,
                                        :action_type,
                                        :action,
                                        :action_memo)
  end
end
