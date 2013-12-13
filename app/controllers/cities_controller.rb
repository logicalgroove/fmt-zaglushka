class CitiesController < ApplicationController
  expose(:city) { City.find_or_create_by(name: params[:city][:name],
                                    latitude: params[:city][:latitude],
                                    longitude: params[:city][:longitude],
                                    g_id: params[:city][:g_id])}
  expose(:cities)
  expose(:user) {User.find(params[:user_id]) if params[:user_id]}

  def create
    respond_to do |format|
      country = Country.find_or_initialize_by(name: params[:city][:country])
      country.cities << city
      country.save
      city.country = country
      city.save
      unless user.cities.include?(city)
        city.users << user
        format.js
      else
        format.json { render json: { :error => 'City is already there.' } }
      end
    end
  end

  def update
    respond_to do |format|
      if city.save
        format.html { redirect_to city, notice: 'City was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: city.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      format.html { redirect_to cities_url }
      format.json { head :no_content }
    end
  end
end
