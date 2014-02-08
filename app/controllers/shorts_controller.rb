class ShortsController < ApplicationController
  expose(:short) {params[:id]}

  def show
    user = User.where(:short_id => short).first
    respond_to do |format|
      session[:user_id] = user.id
      format.html { redirect_to user_path(user) }
    end
  end
end
