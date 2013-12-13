Then /^I should see the following (.*?) in the database:$/ do |model_name, table|
  model = model_name.titleize.delete(' ').constantize
  model.where(table.rows_hash.symbolize_keys).count.should eq 1
end

Then /^I should not see the following (.*?) in the database:$/ do |model_name, table|
  model = model_name.titleize.delete(' ').constantize
  model.where(table.rows_hash.symbolize_keys).count.should eq 0
end

