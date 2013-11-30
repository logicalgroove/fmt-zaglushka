class City
  include Mongoid::Document
  field :name, type: String
  field :latitude, type: String
  field :longitude, type: String
  field :g_id, type: String

  has_and_belongs_to_many :users
  before_destroy { users.clear }
end
