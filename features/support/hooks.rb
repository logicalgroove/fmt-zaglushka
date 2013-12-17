Before do
  DatabaseCleaner.clean
  $browser.delete_cookie('_session', 'path=/') if $browser
end
After do
  Time.zone = 'GMT'
  $browser.delete_cookie('_session', 'path=/') if $browser
  $browser.delete_all_visible_cookies if $browser
end
Around('@email') do |scenario, block|
  ActionMailer::Base.delivery_method = :test
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.deliveries.clear
  block.call
end
