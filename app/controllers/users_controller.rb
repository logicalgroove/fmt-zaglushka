class UsersController < ApplicationController
  expose(:user)
  expose(:users)

  def show
    gon.cities = []
    gon.user_id = user.id.to_s
    user.cities.each do |city|
      gon.cities.push({name: city.name, latitude: city.latitude, longitude: city.longitude})
    end
  end

  def create
    respond_to do |format|
      if user.save
        format.js { render js:  "window.location.replace('#{user_path(user)}')" }
      else
        format.js
      end
    end
  end

  def update

    respond_to do |format|
      if user.save
        format.html { redirect_to user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

end
