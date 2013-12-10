class Country
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  has_many :cities
end
