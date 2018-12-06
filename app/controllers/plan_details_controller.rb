# frozen_string_literal: true

class PlanDetailsController < ApplicationController
  before_action :logged_in_user

  def show; end

  def create
    plan_detail = PlanDetail.find(params[:plan_detail])
    @plan = plan_detail.plan
    respond_to do |format|
      format.html { redirect_to edit_plan(@plan) }
      format.js
    end
  end

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
