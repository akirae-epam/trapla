# frozen_string_literal: true

class UsersController < ApplicationController
  # ———————————————————————————————before_action———————————————————————————————
  before_action :logged_in_user, only: %i[destroy index edit update]
  before_action :correct_user,   only: %i[destroy edit update]

  # ———————————————————————————————actions———————————————————————————————
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @plans = @user.plans.paginate(page: params[:page])
    redirect_to(root_url) && return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_account_activation_email
      flash[:info] = 'Please check your email to activate your account.'
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
    if @user.update_attributes(user_params)
      flash[:infomation] = 'User infomation updated'
      redirect_to @user
    else
      render 'users/edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if current_user.admin?
      user.destroy
      flash[:success] = 'User deleted'
      redirect_to users_url
    else
      user.destroy
      session.delete(:user_id)
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
      flash[:success] = 'User deleted'
      redirect_to root_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:new_user_image, :name, :email, :password, :password_confirmation)
  end

  # 正しいユーザ（手を加える対象ユーザ自身もしくは管理者）であることを確認
  def correct_user
    unless current_user.admin?
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
  end
end
