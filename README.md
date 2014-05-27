# Tutorial Series: Part 1 - Integration Testing
[TOC]

## Background

For this tutorial, I'm going to go through a standalone toy app that revolves around Drake.  It's going to go to a couple websites, interact with them and ensure some key content is in place.

The toy app will focus primarily on two tools: Cucumber and Capybara.  It will show the very basics of these and how each one interacts with one another.

The last portion will be a case study of using Cucumber, Capybara, and Pickle with the current Yoganonymous project, krsna.  Pickle brings in another layer of abstraction that helps do even more complex things with this Integration Testing framework.

## Materials and Methods

This section will begin with describing what integration testing is, where it belongs in the Software Engineering Lifecyle.  It will then go through the tools, Cucumber and Capybara, we are using in our first two experiments.  From that point, we will introduce Pickle and demonstrate how it is being used in krsna.

### Integration Testing

Integration testing has come into spotlight recently after DHH published ["TDD is dead. Long live testing."](http://david.heinemeierhansson.com/2014/tdd-is-dead-long-live-testing.html) post.  He emphasized a desire to replace controller unit testing with "higher level system tests through Capybara". Integration testing is in between unit testing (currently using rspec for model and controller testing in several projects) and Validation/Verification Testing (done by software testers).

### Cucumber

At the top of this integration testing stack is the highest level containing human-readable feature descriptions and scenarios.  Cucumber utilizes Gherkin as the language to describe these features and scenarios.  Gherkin is a "Business Readable, Domain Specific Language".  A Gherkin source file contains a few pieces:

* Feature - there is only one feature per file
    - Scenarios - there can be multiple scenarios to prove the feature is implemented
        + Given/When/Then are the steps you use to prove these scenarios

What you need to know about these feature files is a feature gives a vague description of the feature.  Scenarios setup descriptive stories to test different aspects of a feature.  The feature and scenarios descriptions are really only decorative and not functionally parsed.  The Given/When/Then steps are describing steps a user takes when interacting with a webapp.

```
Feature: Wheelchair Jimmy Fan
    As Drake's number one fan
    I want to Start From The Bottom and scour the internet for the best Drake-related content
    so I can Take Care and prove Nothing Was The Same

    Scenario: I want to search my favorite subreddit
        Given I am logged into reddit
```

### Capybara

In order to interact with a webapp, Capybara is used.  It can use different drivers that render out the full page of content.  Selenium is built in but WebKit and PhantomJS can be used.  The Capybara DSL allows you to define your Given/When/Then steps.  For example, to define the `Given I am logged into reddit` step, we can use Capybara like this:

```ruby
Given(/^I am logged into reddit$/) do
    visit "http://www.reddit.com"
    within("#login_login-main") do
        fill_in 'user', :with => 'startedfromthetut'
        fill_in 'passwd', :with => 'startedfromthebottom'
    end
    click_link 'login'
end
```

The Given step is defined by passing in a Regular Expression.  This is a fairly basic one and only uses the special characters `^` and `$` to anchor the sentence to the beginning at ending of the string, respectivley.

### Experiment: Drake Subreddit

Now that we have the the login step defined we can work on navigating reddit to fetch some content for us.

We'll obviously want to visit our favorite subreddit, [/r/WheelchairJimmy](http://www.reddit.com/r/WheelchairJimmy) to do this.

```ruby
And I go to my favorite subreddit "WheelchairJimmy" # features/step_definitions/reddit_steps.rb:9

Given /^I go to my favorite subreddit "(.*?)"$/ do |subreddit|
	visit "http://www.reddit.com/r/#{subreddit}"
end
```

Once on this subreddit, we'll want to search for one of our favorite [memes](http://knowyourmeme.com/memes/came-here-to-fuck-bitches).

```ruby
When I search for "I came here to fuck bitches"     # features/step_definitions/reddit_steps.rb:13

When(/^I search for "(.*?)"$/) do |search_term|
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
```

Since that is the one and only link, I want to click it.

```ruby
And I click the first link                          # features/step_definitions/reddit_steps.rb:33

When(/^I click the first link$/) do
  within('.linklisting') do
    find('.title .may-blank').click
  end
end
```

From there, I want to see Drake's swag by saving and opening this page in another browser.

```ruby
Then I should see Drake's swag                      # features/step_definitions/reddit_steps.rb:39

Then(/^I should see Drake's swag$/) do
  save_and_open_page
end
```

I can also save this image and use it in this guide.

```ruby
And I want to save a screenshot as "swag"           # features/step_definitions/reddit_steps.rb:43

Then(/^I want to save a screenshot as "(.*?)"$/) do |image_name|
	page.save_screenshot("#{Dir.pwd}/images/#{image_name}.png")
end
```

The spoils of our labor:

![Jimmy Swag](https://bytebucket.org/42dev/tutorial-series-part-1-integration-testing/raw/ebca4969fb6926301c873a8ca49fe3353fbbe4bf/images/swag.png?token=038906fdae3c58745f45c14b393952fdd1c76c43)
### Pickle

### Case Study: Yoganonymous

## Results

## Discussion
