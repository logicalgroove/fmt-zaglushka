class CitiesController < ApplicationController
  expose(:city) { City.find_or_create_by(name: params[:city][:name],
                                    latitude: params[:city][:latitude],
                                    longitude: params[:city][:longitude],
                                    g_id: params[:city][:g_id])}
  expose(:cities)
  expose(:user) {User.find(params[:user_id]) if params[:user_id]}
  before_filter :require_login, :only => :create

  def create
    respond_to do |format|
      country = Country.find_or_initialize_by(name: params[:city][:country])
      country.cities << city unless country.city_ids.include?(city.id)
      country.users << user unless country.user_ids.include?(user.id)
      country.save
      city.country = country
      city.save
      unless user.cities.include?(city)
        city.users << user
        user.add_city_to_image_world_map(city)
        format.js
      else
        format.js { render partial: 'error'}
      end
    end
  end

end
