class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String

  has_and_belongs_to_many :cities

  def add_city(city)
    self.cities << city
    self.save
  end
end
