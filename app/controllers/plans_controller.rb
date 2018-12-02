class PlansController < ApplicationController
  before_action :logged_in_user, :set_action_type

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
    @plan = current_user.plans.find(params[:id])
  end

  def update
    @plan = current_user.plans.find(params[:id])
    if @plan.update_attributes(plan_params)
      flash[:success] = 'プランを更新しました。'
      redirect_to user_path(current_user)
    else
      render 'edit'
    end
  end

  def destroy
  end

  private
    def plan_params
      params.require(:plan).permit(:title, :content)
    end

    def set_action_type
      @action_type_move = {walk: '徒歩',
                           car: '車',
                           train: '電車',
                           bus: 'バス',
                           taxi: 'タクシー',
                           air: '飛行機',
                           ship: '船',
                           etc: 'その他'}
      @action_type_visit = {tourism: '観光',
                           meal: '食事',
                           work: '仕事',
                           checkin: 'チェックイン',
                           sleepin: '就寝',
                           wakeup: '起床',
                           checkout: 'チェックアウト',
                           etc: 'その他'}
    end

end
