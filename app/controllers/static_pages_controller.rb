# frozen_string_literal: true

class StaticPagesController < ApplicationController
  include SessionsHelper

  def home
    return unless logged_in?

    @user = current_user
    @plans = @user.feed.paginate(page: params[:page])
  end
end
