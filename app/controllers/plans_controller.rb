# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :logged_in_user, :set_action_type
  before_action :correct_user, only: %i[destroy edit update]

  def index; end

  def show
    @plan = Plan.find(params[:id])
    @plan_details = @plan.plan_details
  end

  def new
    @plan = current_user.plans.new
    @new_plan_detail = @plan.plan_details.new
  end

  def create
    @plan = current_user.plans.build(plan_params)
    if @plan.save
      flash[:success] = 'プランを作成しました'
      redirect_to plan_path(@plan)
    else
      render 'new'
    end
  end

  def edit
    @plan = current_user.plans.find_by(id: params[:id])
    @plan_details = @plan.plan_details
    @new_plan_detail = @plan.plan_details.new
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

  # 正しいユーザ（手を加える対象ユーザ自身もしくは管理者）であることを確認
  def correct_user
    unless current_user.nil? && current_user.admin?
      plan = current_user.plans.find_by(id: params[:id])
      if !!plan
        redirect_to(root_url) unless plan.user == current_user
      else
        redirect_to(root_url)
      end
    end
  end

  def plan_params
    params.require(:plan).permit(:title, :content)
  end

  def set_action_type
    @action_type_move = { walk: '徒歩',
                          car: '車',
                          train: '電車',
                          bus: 'バス',
                          taxi: 'タクシー',
                          air: '飛行機',
                          ship: '船',
                          etc: 'その他' }
    @action_type_visit = { tourism: '観光',
                           meal: '食事',
                           work: '仕事',
                           checkin: 'チェックイン',
                           sleepin: '就寝',
                           wakeup: '起床',
                           checkout: 'チェックアウト',
                           etc: 'その他' }
  end

end
