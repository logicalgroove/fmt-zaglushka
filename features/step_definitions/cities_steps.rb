def create_cities
  city1 = FactoryGirl.create(:city, name: 'Barcelona')
  city2 = FactoryGirl.create(:city, name: 'New York')
  city3 = FactoryGirl.create(:city, name: 'Havana')
end

Given /^there are some cities in the database$/ do
  create_cities
end

And /^I search google maps for "(.*?)"$/ do |place_name|
  city_name = place_name.split(',')[0].strip
  country_name = place_name.split(',')[1].strip
  page.execute_script("$.ajax({type: 'POST', url: '/cities', data: {city: {name: '#{city_name}', latitude: '11', longitude: '22', g_id: '33', country: '#{country_name}'}, user_id: gon.user_id}})")
end

Then /^I should have "(.*?)" as travelled cities$/ do |city_name|
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

Then /^I should have "(.*?)" cities as travelled cities$/ do |count|
  @user.reload
  @user.city_count.should == count.to_s
end

Then /^should be only one "(.*?)" on the page$/ do |city_name|
  page.all("ul#cities li").count.should eql(1)
end

Then(/^I should have "(.*?)" counties as travelled counties$/) do |count|
  @user.reload
  @user.countries_count.should == count.to_s
end
