Given(/^I am logged into reddit$/) do
	visit 'http://www.reddit.com'
	within("#login_login-main") do
    	fill_in 'user', :with => 'startedfromthetut'
    	fill_in 'passwd', :with => 'startedfromthebottom'
  	end
end