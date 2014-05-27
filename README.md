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
	    + Background - this is similar to `before(:each)` blocks in rspec and are run before each scenario.
        + Given/When/Then are the steps you use to prove these scenarios
		  - These steps need to be defined in `step_definitions/*_steps.rb` with Capybara methods.

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

We've gone over a toy app for browsing the internet but this was outside the context of a rails app.  Within a rails app, chances are you don't want to create instances of a model by using forms.  Using [Pickle](https://github.com/ianwhite/pickle), we are able to easily create one or more instances that we can then use in the rest of our tests.  Here's a quick example of creating a published post using Pickle:

```ruby
And a post exists with title: "How many gold rings?", content: "Eight gold rings like I'm Sha-Shabba Ranks"
```

This step calls `FactoryGirl(:post)` and passes in the title and the content.

In the next section, we'll go over more complicated examples of how Pickle was used in [Yoganonymous](https://bitbucket.org/42dev/krsna).

### Case Study: [Yoganonymous](https://bitbucket.org/42dev/krsna)

In the previous secion, we briefly touched on using Pickle for stubbing instances.  This section covers how Cucumber and Pickle were used in [Yoganonymous](https://bitbucket.org/42dev/krsna).

Only admins can view posts on Yoganonymous so if we want a regular user to view a post, it needs to be published.  If you were to use `Given a published post exists` instead, it would call `FactoryGirl(:published_post)`.  You can also create a batch of posts by saying `Given 5 posts exist` and five posts will be created with the FactoryGirl defined attributes.

You can also pass in tables of data in order to create a bunch of instances that all need to have custom attributes.  The following example has had ` And a category "Wellness" exists with name: "Wellness"` called before.  By using `category "Wellness"` instead of just `category`, we can then refer to this instance in this example:

```ruby
| subcategory   | name          | parent              |
| Recipes       | Recipes       | category "Wellness" |
| Green         | Green         | category "Wellness" |
| Relationships | Relationships | category "Wellness" |
```

The `subcategory` column is what method FactoryGirl will call.  By passing in an label, we can refer to these categories later.  In this example, both the label and the name are the same.  This isn't always the case:

```ruby
| post         | title                  | category                 | 
| Best Recipes | Best Ayurvedic Recipes | category "Recipes"       | 
| Bein         | Being Green            | category "Green"         | 
| Carrie       | Yoga And The City      | category "Relationships" |
```

Here we are creating three posts, the labels and the titles differ.  We also assign the category these posts belong to by refering to the subcategories we made.  Now that we have these categories and posts created, we can then go to the proper page.

```ruby
When I go to the page for the "Wellness" category                      # features/step_definitions/pickle_steps.rb:18
# pickle_steps.rb
When /^I go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

# support/paths.rb helper file
def path_to(page_name)
	case page_name
	...
    when /^the page for the "(.+)" category$/
      "/categories/#{$1.downcase}"
	...
    end
end
```

Using these steps, `/categories/wellness` is returned and we visit this page.  Once on that page, we want to make sure certain content is on the page:

```ruby
And I should see the title for the post "Bein"                      # features/step_definitions/post_steps.rb:11
And I should see the full category name for the post "Bein"         # features/step_definitions/post_steps.rb:11

Then(/^I should see the (.+) for #{capture_model}$/) do |attribute, captured_model|
  model = model(captured_model)
  page.should have_content model.send(attribute.gsub(' ', '_'))
end
```

This step definition was written by me but it is using the helper methods `capture_model` and `model()` provided by Pickle.  This will check the page and make sure both the `post.title` and `post.full_category_name` are on the page.

## Recap & Discussion

In this tutorial, we introduced what Integration Testing is, what the structure of a Cucumber feature file and how Capybara interacts with a webpage.  We went through a toy example that browsed reddit and looked at a little bit more complicated example used in Yoganonymous.  These generated tests can then be exported to [HTML reports]() to be viewed by anyone.

Although Cucumber is a useful tool that provides human-readable, business-facing tests, it might not be the best solution for the project you are working on.  You can use Capybara with RSpec or tools like [Steak](https://github.com/cavalle/steak) to achieve similar results.

For more info on Cucumber and Integration Testing, here are some useful resources:

* [Beginning With Cucumber](http://railscasts.com/episodes/155-beginning-with-cucumber) Railscast
* [More on Cucumber](http://railscasts.com/episodes/159-more-on-cucumber) Railscast
* [Pickle with Cucumber](http://railscasts.com/episodes/186-pickle-with-cucumber) Railscast
* [Cucumber](http://cukes.info/) homepage
* [Capybara](https://github.com/jnicklas/capybara) GitHub Page
