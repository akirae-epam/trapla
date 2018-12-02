class PlansController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,   only: [:destroy, :edit, :update]

  def index
  end

  def show
  end

  def new
    @plan = current_user.plans.new
  end

  def create
    @plan = current_user.plans.build(plan_params)
    if @plan.save
      flash[:success] = 'プランを作成しました'
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end

  def edit
    @plan = current_user.plans.find_by(id: params[:id])
  end

  def update
    @plan = current_user.plans.find(params[:id])
    if @plan.update_attributes(plan_params)
      flash[:success] = 'プランを更新しました。'
      redirect_to current_user
    else
      render 'edit'
    end
  end

  def destroy
    Plan.find(params[:id]).destroy
    flash[:success] = "プランを削除しました。"
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

end
