def create_cities
  city1 = FactoryGirl.create(:city, name: 'Barcelona')
  city2 = FactoryGirl.create(:city, name: 'New York')
  city3 = FactoryGirl.create(:city, name: 'Havana')
end

Given /^there are some cities in the database$/ do
  create_cities
end

And /^I search google maps for "(.*?)" city$/ do |city_name|
  page.execute_script("$.ajax({type: 'POST', url: '/cities', data: {city: {name: '#{city_name}', latitude: '11', longitude: '22', g_id: '33'}, user_id: gon.user_id}})")
end

Then /^this user should have "(.*?)" as travelled cities$/ do |city_name|
  city = City.find_by(name: city_name)
  @user.reload
  @user.cities.should include(city)
end

When(/^should be only one "(.*?)" in database$/) do |city_name|
  city = City.find_by(name: city_name)
  City.count.should eq(1)
end

When(/^I should have "(.*?)" as unique city in my travelled cities$/) do |city_name|
  @user.reload
  @user.cities.where(:name =~ /#{city_name}/).count.should eq(1)
end

Then /^this user should see "(.*?)" cities as travelled cities$/ do |count|
  @user.reload
  @user.city_count.should == count.to_s
end
