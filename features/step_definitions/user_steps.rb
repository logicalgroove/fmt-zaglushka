def mock_sessions
  if Capybara.current_driver == :webkit
    page.driver.browser.set_cookie("stub_user_id=#{@user.id}; domain=127.0.0.1")
  else
    cookie_jar = Capybara.current_session.driver.browser.current_session.instance_variable_get(:@rack_mock_session).cookie_jar
    cookie_jar[:stub_user_id] = @user.id
  end
end

def clear_session
  browser = Capybara.current_session.driver.browser
    browser.clear_cookies
end

Given /^I exist as a user$/ do
  @user = FactoryGirl.create(:user, email: 'user@g.com')
  mock_sessions
end

When /^I visit my user page$/ do
  visit user_path(@user)
end

Given /^I visit page from mobile device$/  do
  agent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1_2 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7D11 Safari/528.16"
  page.driver.browser.header('User-Agent', agent)
  visit user_path(@user)
  mock_sessions
end

When /^I visit admin page$/ do
  encoded_login = ["admin:secret"].pack("m*")
  page.driver.header 'Authorization', "Basic #{encoded_login}"
  visit '/admin'
end

When /^I visit short link "(.*?)"$/  do |short_id|
  user = User.where(short_id: short_id).last
  visit user_path(user)
end

Given /^there is a user with "(.*?)" email$/ do |email|
  @user = FactoryGirl.create(:user, email: email, short_id: 'blah')
  mock_sessions
end

Given /^this user has the following cities in the database:$/  do |table|
    city_values = table.rows_hash.symbolize_keys
    city_values[:user_ids] = @user.id
    city = FactoryGirl.create(:city, city_values)
end

When /^I visit "(.*?)" page$/  do |email|
  clear_session
  user = User.where(email: email).last
  visit user_path(user)
end

Then /^I should have "(.*?)" as shared option$/ do |network|
  @user.reload
  @user.shared_to.should == network
end

Given /^this user has the "(.*?)" field set to "(.*?)"$/  do |field, value|
  user = @user
  user.update_attributes(field => value)
end

Then /^I should see "(.*?)" after "(.*?)" on the page$/  do |arg1, arg2|
  page.body.should =~ /#{arg1}.*#{arg2}/m
end
