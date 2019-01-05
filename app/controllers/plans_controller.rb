# frozen_string_literal: true

class PlansController < ApplicationController
  include PlansHelper
  before_action :logged_in_user, except: :show
  before_action :set_action_type
  before_action :correct_user, only: %i[edit update destroy]

  def show
    @plan = Plan.find(params[:id])
    @plan_details = @plan.plan_details.order(:date)
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
    @plan_details = @plan.plan_details.order(:date)
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

  def copy
    store_location
    @base_plan = Plan.find_by(id: params[:id])
    redirect_back_or(root_url) if @base_plan.nil?

    @plan = @base_plan.dup
    @plan.user_id = current_user.id
    redirect_back_or(root_url) unless @plan.save

    @base_plan_details = @base_plan.plan_details
    @base_plan_details.each do |base_plan_detail|
      plan_detail = base_plan_detail.dup
      plan_detail.plan_id = @plan.id
      next if plan_detail.save

      @plan.destroy
      redirect_back_or(root_url)
    end
    redirect_to(edit_plan_path(@plan))
  end

  def search
    @user = current_user
    keyword = params[:keyword]
    @plans = if keyword == ''
               Plan.all.paginate(page: params[:page])
             else
               Plan.where('title LIKE ? OR content LIKE ?',
                          "%#{keyword}%",
                          "%#{keyword}%").paginate(page: params[:page])
             end
    render 'static_pages/home'
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
