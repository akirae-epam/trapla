# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = 'このアカウントはまだ登録が完了していません。'
        message += '登録されたメールアドレスに登録完了用のリンクを記載したメールが送られていますので'
        message += 'ご確認をお願いします。'
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # ログイン失敗したときの処理
      flash.now[:danger] = 'メールアドレスとパスワードの組み合わせが誤っています。' # 本当は正しくない
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
