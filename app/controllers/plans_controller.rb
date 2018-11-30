class PlansController < ApplicationController
  before_action :logged_in_user, :set_action_type

  def index
  end

  def show
  end

  def new
    @user = current_user
    @plan = @user.plans.new
    @plan_detail = @plan.plan_details.new
    @belonging = @plan_detail.belongings.new
    @payment = @plan_detail.payments.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
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
