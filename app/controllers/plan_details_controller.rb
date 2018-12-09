# frozen_string_literal: true

class PlanDetailsController < ApplicationController
  before_action :logged_in_user, :correct_user, :set_action_type

  def show; end

  def create
    @plan_detail = @plan.plan_details.build(plan_detail_params)
    if @plan_detail.save
      @plan_details = @plan.plan_details.reload
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

  def correct_user
    @plan = current_user.plans.find_by(id: params[:plan_id])
    redirect_to root_url if @plan.nil?
  end

  def plan_detail_params
    params.require(:plan_detail).permit(:date,
                                        :place,
                                        :action_type,
                                        :action,
                                        :action_memo)
  end
end
