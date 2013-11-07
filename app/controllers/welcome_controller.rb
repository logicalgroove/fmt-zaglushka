class WelcomeController < ApplicationController
  expose(:user) {User.new}

  def index
  end
end
