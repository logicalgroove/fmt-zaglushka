Then /^I should see an "([^\"]*)" e\-mail$/ do |arg1|
  mail = User.last.email
  @email = ActionMailer::Base.deliveries.last
  @email.to.should include mail
  @email.subject.should include(arg1)
end
