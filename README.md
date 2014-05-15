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

### Experiment 1: Drake Subreddit

### Experiment 2: Google Images

### Pickle

### Case Study: Yoganonymous

## Results

## Discussion