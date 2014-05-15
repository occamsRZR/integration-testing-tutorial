Given /^I am logged into reddit$/ do
	visit 'http://www.reddit.com'
	within("#login_login-main") do
    	fill_in 'user', :with => 'startedfromthetut'
    	fill_in 'passwd', :with => 'startedfromthebottom'
  	end
end

Given /^I go to my favorite subreddit "(.*?)"$/ do |subreddit|
	visit "http://www.reddit.com/r/#{subreddit}"
end

When(/^I search for "(.*?)"$/) do |search_term|
  find(:xpath, '//*[@id="searchexpando"]/label/input').set(true)

  within "#search" do

  	fill_in 'search reddit', with: search_term + '\n'
  end
end

When(/^I click the first link$/) do
	within('.linklisting') do
		click "I came here to fuck bitches"
	end
end

Then(/^I should see Drake's swag$/) do
	page.save_screenshot("images/#{image_name}.png")
end

Then(/^I want to save a screenshot as "(.*?)"$/) do |image_name|
	page.save_screenshot("images/#{image_name}.png")
end
