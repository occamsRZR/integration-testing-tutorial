Feature: Wheelchair Jimmy Fan
	As Drake's number one fan
	I want to Start From The Bottom and scour the internet for the best Drake-related content
	so I can Take Care and prove Nothing Was The Same

	Scenario: I want to search my favorite subreddit
		Given I am logged into reddit
		And I go to my favorite subreddit "WheelchairJimmy"
		When I search for "I came here to fuck bitches"
		And I want to save and open
		And I click the first link
		Then I should see Drake's swag
		And I want to save a screenshot as "swag.png"
	Scenario: I want to use YouTube