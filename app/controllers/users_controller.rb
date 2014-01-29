class UsersController < ApplicationController
  expose(:user)
  expose(:users)
  expose(:short)

  def show
    gon.cities = []
    gon.cities_count = user.city_count
    gon.map_image = user.world_map_name
    gon.user_id = user.id.to_s
    user.cities.each do |city|
      gon.cities.push({name: "#{city.name}, #{city.country.name}", latitude: city.latitude, longitude: city.longitude})
    end
  end

  def create
    respond_to do |format|
      user.short_id = Digest::SHA1.hexdigest([Time.now, user.email].join)[0..4]
      if user.save
        UserMailer.registration_confirmation(user).deliver
        session[:user_id] = user.id
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
