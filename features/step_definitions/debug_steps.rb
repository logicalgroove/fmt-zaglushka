def wait_for_ajax(timeout=5, step=0.1)
  start_time = Time.now
  page.evaluate_script('jQuery.isReady&&jQuery.active==0').class.should_not eql(String) until page.evaluate_script('jQuery.isReady&&jQuery.active==0') or (start_time + timeout.seconds) < Time.now do
    sleep step
  end
end

Then /^print the page contents$/ do
  puts page.body
end

Then /^show me the page$/ do
  puts current_url
end

Then /^show me the "([^"]*)" table$/ do |name|
  ap name.constantize.all.map {|p| p}
end

Then /^take a screenshot$/ do
  screenshot_and_save_page
end

When /^I wait for the ajax request to finish$/ do
  wait_for_ajax
end

Then /^print a line$/ do
  ap '-'*40
end
