class UsersController < ApplicationController
  expose(:user)
  expose(:users)
  expose(:short)
  expose(:city) {City.where(:id => params['city_id']).first}

  before_filter :restrict_to_owner, :only => [:delete_city]

  def show
    gon.cities = []
    gon.cities_count = user.city_count
    gon.map_image = user.world_map_name
    gon.user_id = user.id.to_s
    gon.cities = {}
    gon.is_logged_in = is_logged_in
    user.cities.each do |city|
      gon.cities[city.id] = {name: "#{city.name}, #{city.country.name}", latitude: city.latitude, longitude: city.longitude, user_percentage: "#{city.user_percentage}" }
    end
  end

  def create
    respond_to do |format|
      user.short_id = Digest::SHA1.hexdigest([Time.now, user.email].join)[0..4]
      user.mobile = mobile?
      if user.save
        user.create_image_world_map
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

  def delete_city
    respond_to do |format|
      user.delete_city(city)
      format.js
    end
  end

  def shared_to
    render nothing: true
    user.update_attributes(:shared_to => params['service'])
    ap params['service']
  end

  private

  def restrict_to_owner
    raise ActionController::RoutingError.new('Not Found') if !is_logged_in
  end
end
