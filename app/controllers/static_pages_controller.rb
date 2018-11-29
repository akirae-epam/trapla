class StaticPagesController < ApplicationController
include SessionsHelper

  def home
    if logged_in?
      @user = current_user
      @plans = Plan.all.paginate(page: params[:page])
    end
  end

end
