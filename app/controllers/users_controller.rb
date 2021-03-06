# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[destroy index edit update following followers]
  before_action :correct_user, only: %i[destroy edit update]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to(root_url) && return unless @user.activated?
    @plans = @user.plans.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_account_activation_email
      flash[:info] = '登録いただいたメールアドレスに登録完了のためのリンクを送付しました。'
      redirect_to root_url
    else
      render 'users/new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:infomation] = 'ユーザ情報を更新しました。'
      redirect_to @user
    else
      render 'users/edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    if current_user.admin?
      flash[:success] = 'ユーザを削除しました。'
      redirect_to users_url
    else
      session.delete(:user_id)
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
      flash[:success] = 'ユーザを削除しました。'
      redirect_to root_url
    end
  end

  def following
    @title = 'Following'
    @user  = User.find(params[:id])
    @users = @user.following
    respond_to do |format|
      format.html { redirect_to(@user) }
      format.js
    end
  end

  def followers
    @title = 'Followers'
    @user  = User.find(params[:id])
    @users = @user.followers
    respond_to do |format|
      format.html { redirect_to(@user) }
      format.js
    end
  end

  private

  def user_params
    params.require(:user).permit(:new_user_image,
                                 :name,
                                 :email,
                                 :password,
                                 :password_confirmation)
  end

  # 正しいユーザ（手を加える対象ユーザ自身もしくは管理者）であることを確認
  def correct_user
    return if current_user.admin?

    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
