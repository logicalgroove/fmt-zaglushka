class User
  include Mongoid::Document
  include Mongoid::Timestamps
  before_validation :downcase_email
  field :email, type: String
  validates :email,:presence => true,
                   :format => {:with =>  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i},
                   :uniqueness => true
  has_and_belongs_to_many :cities
  has_and_belongs_to_many :countries

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

  def world_map_name
    user_map = "world_map_#{id.to_s}.jpg"
    default_map = 'world_map.jpg'
    return File.file?("public/#{user_map}") ? user_map : default_map
  end

  def save_mini_map(city)
    map = MiniMagick::Image.open("public/#{world_map_name}")
    marker = MiniMagick::Image.open('app/assets/images/pin.png')

    map = map.composite(marker) do |c|
      c.compose "Over"
      c.geometry "+#{city.longitude_in_px}+#{city.latitude_in_px}"
    end

    map.write "public/world_map_#{id.to_s}.jpg"
  end

  private

  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end
end
