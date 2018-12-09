# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  # ユーザーのログインを確認する
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'ログインしてください。'
    redirect_to login_url
  end

  def set_action_type
    @action_type_move = { walk: '徒歩',
                          car: '車',
                          train: '電車',
                          bus: 'バス',
                          taxi: 'タクシー',
                          airplane: '飛行機',
                          ship: '船',
                          move_etc: 'その他' }
    @action_type_visit = { tourism: '観光',
                           meal: '食事',
                           work: '仕事',
                           checkin: 'チェックイン',
                           sleepin: '就寝',
                           wakeup: '起床',
                           checkout: 'チェックアウト',
                           visit_etc: 'その他' }
  end
end
