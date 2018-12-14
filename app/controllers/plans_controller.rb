# frozen_string_literal: true

class PlansController < ApplicationController
  include PlansHelper
  before_action :logged_in_user, :set_action_type
  before_action :correct_user, only: %i[edit update destroy]

  def show
    @plan = Plan.find(params[:id])
    @plan_details = @plan.plan_details
    plan_belongings_payments(@plan)
  end

  def new
    @plan = current_user.plans.new
  end

  def create
    @plan = current_user.plans.build(plan_params)
    if @plan.save
      flash[:success] = 'プランを作成しました。'
      redirect_to edit_plan_path(@plan)
    else
      render 'new'
    end
  end

  def edit
    @plan = current_user.plans.find_by(id: params[:id])
    @plan_details = @plan.plan_details
    @new_plan_detail = @plan.plan_details.new
    plan_belongings_payments(@plan)
  end

  def update
    @plan = current_user.plans.find(params[:id])
    if @plan.update(plan_params)
      flash[:success] = 'プランを更新しました。'
      redirect_to plan_path(@plan)
    else
      render 'edit'
    end
  end

  def destroy
    Plan.find(params[:id]).destroy
    flash[:success] = 'プランを削除しました。'
    redirect_to current_user
  end

  private

  def plan_params
    params.require(:plan).permit(:title, :content)
  end

  # 正しいユーザ（手を加える対象ユーザ自身もしくは管理者）であることを確認
  def correct_user
    @user = current_user
    plan = current_user.plans.find_by(id: params[:id])
    if !plan.nil?
      redirect_to(root_url) unless plan.user == current_user
    else
      redirect_to(root_url)
    end
  end
end
