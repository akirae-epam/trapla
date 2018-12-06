# frozen_string_literal: true

class PlanDetailsController < ApplicationController
  before_action :logged_in_user

  def show; end

  def create
    @plan = Plan.find(params[:plan_id])
    @plan_detail = @plan.plan_details.build(plan_detail_params)
    if @plan_detail.save
      respond_to do |format|
        format.html { redirect_to edit_plan_path(@plan) }
        format.js
      end
    else
      render 'plans/edit'
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
