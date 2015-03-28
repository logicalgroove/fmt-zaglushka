class WelcomeController < ApplicationController
  expose(:user) {User.new}

  def index
  end

  def travels
    render layout: 'travels'
  end
end
