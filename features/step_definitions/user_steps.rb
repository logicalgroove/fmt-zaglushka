Given /^I exist as a user$/ do
  @user = FactoryGirl.create(:user, email: 'user@g.com')
end

When /^I visit my user page$/ do
  visit user_path(@user)
end

