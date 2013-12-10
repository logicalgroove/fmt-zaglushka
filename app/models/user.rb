class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String

  has_and_belongs_to_many :cities

  def add_city(city)
    self.cities << city
    self.save
  end

  def city_count
    city_ids.count.to_s
  end

  def countries_count
    cities.group_by(&:country_id).count.to_s
  end
end
