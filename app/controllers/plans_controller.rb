class PlansController < ApplicationController
  before_action :logged_in_user

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
    if @plan = current_user.plans.find_by(id: params[:id])
    else
      redirect_to root_path
    end
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
    def plan_params
      params.require(:plan).permit(:title, :content)
    end

end
