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
#  binding.pry
  ##
  # puts cursor inside of search box
  within "#search" do
    fill_in 'search reddit', with: ''
  end
  ##
  # cursor inside of search box opens the info bar
  # check the restrict subreddit checkbox
  within '.infobar' do
    check 'restrict_sr'
  end
  ##
  # put the search term in the field as well as newline to submit query
  within "#search" do
    fill_in 'search reddit', with: search_term + "\n"
  end
end

When(/^I click the first link$/) do
  within('.linklisting') do
    find('.title .may-blank').click
  end
end

Then(/^I should see Drake's swag$/) do
  save_and_open_page
end

Then(/^I want to save a screenshot as "(.*?)"$/) do |image_name|
	page.save_screenshot("/home/edward/repos/tutorial_1-integration_testing/images/#{image_name}.png")
end
