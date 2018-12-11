# frozen_string_literal: true

class PlanDetailsController < ApplicationController
  before_action :logged_in_user, :correct_user, :set_action_type
  before_action :load_plan_detail, only: %i[destroy edit update]

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

  def edit
    respond_to do |format|
      format.html { redirect_to edit_plan_path(@plan) }
      format.js
    end
  end

  def update
    if @plan_detail.update(plan_detail_params)
      flash[:success] = 'アクティビティを更新しました。'
      redirect_to edit_plan_path(@plan)
    else
      respond_to do |format|
        format.html { redirect_to edit_plan_path(@plan) }
        format.js
      end
    end
  end

  def destroy
    @plan_detail.destroy
    @plan_details = @plan_detail.plan.plan_details.reload
    redirect_to edit_plan_path(@plan)
  end

  private

  def load_plan_detail
    @plan_detail = @plan.plan_details.find_by(id: params[:id])
    return if @plan_detail.nil?
  end

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
