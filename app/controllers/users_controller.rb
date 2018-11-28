class UsersController < ApplicationController
# ———————————————————————————————before_action———————————————————————————————
  before_action :logged_in_user, only: [:destroy, :index, :edit, :update]
  before_action :correct_user,   only: [:destroy, :edit, :update]

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # 正しいユーザ（手を加える対象ユーザ自身もしくは管理者）であることを確認
  def correct_user
    if !current_user.admin?
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
  end

# ———————————————————————————————actions———————————————————————————————
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
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
      flash[:infomation] = "User infomation updated"
      redirect_to @user
    else
      render 'users/edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if current_user.admin?
      user.destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    else
      user.destroy
      session.delete(:user_id)
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
      flash[:success] = "User deleted"
      redirect_to root_url
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
