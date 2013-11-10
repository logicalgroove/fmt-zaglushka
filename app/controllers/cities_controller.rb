class CitiesController < ApplicationController
  expose(:city)
  expose(:cities)

  def create
    respond_to do |format|
      if city.save
        format.js
      else
        format.json { render json: city.errors, status: :unprocessable_entity }
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
