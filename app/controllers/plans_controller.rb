class PlansController < ApplicationController
  before_action :logged_in_user

  def index
  end

  def show
  end

  def new
    @user = current_user
    @plan = @user.plans.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
