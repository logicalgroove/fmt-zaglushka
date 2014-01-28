class Admin::DashboardController < ApplicationController
  layout 'admin'
  http_basic_authenticate_with name: "admin", password: "secret"


  def index
  end
end
