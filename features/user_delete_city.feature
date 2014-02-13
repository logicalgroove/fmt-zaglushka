Feature: User delete city
  Background:
    Given I exist as a user
    When I visit my user page
    And I wait for 8 seconds
    And I search google maps for "Barcelona, Spain"
    And I wait for ajax request to finish

  @javascript
  Scenario: User deletes city
    When I refresh the page
    And I wait for 5 seconds
    And I click city marker
    And I click ".city-delete" image
    And I wait for ajax request to finish
    Then I should have "0" cities as travelled cities
    And I should have "0" countries as travelled countries

  @javascript
  Scenario: User should have a proper amount of the countries after city delete from one country
    When I search google maps for "Madrid, Spain"
    And I wait for ajax request to finish
    And I refresh the page
    And I wait for 5 seconds
    And I click city marker
    And I click ".city-delete" image
    And I wait for ajax request to finish
    Then I should have "1" cities as travelled cities
    And I should have "1" countries as travelled countries

