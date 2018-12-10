# frozen_string_literal: true

class PlanDetailsController < ApplicationController
  before_action :logged_in_user, :correct_user, :set_action_type

  def show; end

  def create
    @plan_detail = @plan.plan_details.build(plan_detail_params)
    if @plan_detail.save
      @plan_details = @plan.plan_details.reload
      redirect_to edit_plan_path(@plan)
    else
      render 'plans/edit'
    end
  end

  def update; end

  def destroy
    @plan_detail = @plan.plan_details.find_by(id: params[:id])
    return if @plan_detail.nil?

    @plan_detail.destroy
    @plan_details = @plan_detail.plan.plan_details.reload
    redirect_to edit_plan_path(@plan)
  end

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
