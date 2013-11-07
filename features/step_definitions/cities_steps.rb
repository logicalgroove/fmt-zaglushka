def create_cities
  city1 = FactoryGirl.create(:city, name: 'Barcelona')
  city2 = FactoryGirl.create(:city, name: 'New York')
  city3 = FactoryGirl.create(:city, name: 'Havana')
end

Given /^there are some cities in the database$/ do
  create_cities
end
