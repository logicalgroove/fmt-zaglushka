class City
  include Mongoid::Document
  field :name, type: String
  field :latitude, type: String
  field :longitude, type: String
  field :g_id, type: String
  require 'proj4'

  has_and_belongs_to_many :users
  belongs_to :country

  before_destroy { users.clear }

  IMAGE_GLOBE_SIZE = 1000.0
  IMAGE_GLOBE_CENTER_X = 463.0
  IMAGE_GLOBE_CENTER_Y = 330.0
  DEGREES_TO_RADIANS = Math::PI / 180
  RADIANS_TO_PIXELS = IMAGE_GLOBE_SIZE / (2.0 * Math::PI)
  GOOGLE_PARAMS = "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs"
  MILLER_PARAMS = "+proj=mill +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +R_A +ellps=WGS84 +datum=WGS84 +units=m +no_defs"

  def longitude_in_px
    (IMAGE_GLOBE_CENTER_X + (google_to_miller.x * RADIANS_TO_PIXELS)).to_i
  end

  def latitude_in_px
    f = [ [ Math.sin(google_to_miller.y), -0.9999 ].max, 0.9999 ].min
    (IMAGE_GLOBE_CENTER_Y + (0.5 * Math.log((1.0 + f) / (1.0 - f)) * -RADIANS_TO_PIXELS)).to_i
  end

  def google_to_miller
    google_projection = Proj4::Projection.new(GOOGLE_PARAMS)
    miller_projection = Proj4::Projection.new(MILLER_PARAMS)
    google_location = Proj4::Point.new(
          longitude.to_f * DEGREES_TO_RADIANS,
          latitude.to_f * DEGREES_TO_RADIANS)

    miller_location = google_projection.transform(miller_projection, google_location)
  end

end
