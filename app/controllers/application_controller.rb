class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  helper_method :is_logged_in
  helper_method :mobile?
=begin
  before_action :check

  def check
    unless  params["controller"] == "welcome" && params['action'] == 'travels'
      redirect_to 'http://beta.followmytravel.com'
    end
  end
=end


  private
  if Rails.env.test?
    prepend_before_filter :stub_current_user

    def stub_current_user
      session[:user_id] = cookies[:stub_user_id] if cookies[:stub_user_id]
    end
  end

  def require_login
    if session[:user_id].present?
      current_user
    else
      redirect_to root_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def mobile?
    !!(request.user_agent =~ /Mobile|webOS/)
  end

  def is_logged_in
    user == current_user
  end

end
