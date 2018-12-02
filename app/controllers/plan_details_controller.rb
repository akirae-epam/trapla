# frozen_string_literal: true

class PlanDetailsController < ApplicationController
  before_action :logged_in_user, :set_action_type

  def show; end

  def create; end

  def update; end

  def destroy; end

  private

  def plan_detail_params
    params.require(:plan_detail).permit(:date, :place, :action_type, :action, :action_memo)
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
