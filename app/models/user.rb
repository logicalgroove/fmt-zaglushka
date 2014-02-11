class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :email, type: String
  field :short_id, type: String
  field :mobile, type: Boolean
  has_and_belongs_to_many :cities
  has_and_belongs_to_many :countries

  before_validation :downcase_email

  validates :email, :presence => true, :format => {:with =>  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, :uniqueness => true


  def add_city(city)
    self.cities << city
    self.save
  end

  def delete_city(city)
    cities.delete(city)
    city.delete(self)
  end

  def city_count
    city_ids.count.to_s
  end

  def countries_count
    country_ids.count.to_s
  end

  def world_map_name
    "maps/world_map_#{id.to_s}.jpg"
  end

  def create_image_world_map
    file_name = "public/maps/world_map_#{id.to_s}.jpg"
    map = MiniMagick::Image.open("public/world_map.jpg")
    map.write file_name
    File.chmod(0644, file_name)
  end

  def add_city_to_image_world_map(city)
    file_name = "public/maps/world_map_#{id.to_s}.jpg"

    map = MiniMagick::Image.open(file_name)
    marker = MiniMagick::Image.open('app/assets/images/pin.png')

    map = map.composite(marker) do |c|
      c.compose "Over"
      c.geometry "+#{city.longitude_in_px}+#{city.latitude_in_px}"
    end

    map.write file_name
    File.chmod(0644, file_name)
    save_instagram_map
  end

  def save_instagram_map
    square = MiniMagick::Image.open('public/map_square.jpg')
    map = MiniMagick::Image.open("public/maps/world_map_#{id.to_s}.jpg")
    logo = MiniMagick::Image.open('app/assets/images/fmt-logo-small.png')
    map.resize('800x800')

    square = square.composite(map) do |c|
      c.compose "Over"
      c.geometry "+0+208"
    end

    square = square.composite(logo) do |c|
      c.compose "Over"
      c.geometry "+40+40"
    end

    square.combine_options do |c|
      c.gravity 'Southwest'
      c.font "app/assets/fonts/pfhandbookpro-thin-webfont.ttf"
      c.pointsize '180'
      c.draw "text 40,50 '#{city_count}'"
      c.fill("#fff")
    end

    square.combine_options do |c|
      c.gravity 'Southwest'
      c.font "app/assets/fonts/pfhandbookpro-thin-webfont.ttf"
      c.pointsize '53'
      c.draw "text 40,22 '#{Russian::p(city_count.to_i, 'город', 'города', 'городов')}'"
      c.fill("#fff")
    end

    square.combine_options do |c|
      c.gravity 'Southwest'
      c.font "app/assets/fonts/pfhandbookpro-thin-webfont.ttf"
      c.pointsize '180'
      c.draw "text 240,50 '#{countries_count}'"
      c.fill("#fff")
    end

    square.combine_options do |c|
      c.gravity 'Southwest'
      c.font "app/assets/fonts/pfhandbookpro-thin-webfont.ttf"
      c.pointsize '53'
      c.draw "text 240,22 '#{Russian::p(countries_count.to_i, 'страна', 'страны', 'стран')}'"
      c.fill("#fff")
    end

    file_name = "public/maps/instagram_map_#{id.to_s}.jpg"
    square.write file_name
    File.chmod(0644, file_name)
  end

  def share_text
    "У меня #{city_count}. А у тебя?"
  end

  private

  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end
end
