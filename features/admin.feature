Feature: Admin

  Scenario: Visit admin page
    Given there is a user with "zombie@brain.com" email
    And this user has the following cities in the database:
    | name | Barcelona |
    And this user has the following cities in the database:
    | name | Odessa    |
    When I visit admin page
    Then I should see "zombie@brain.com"
    And I should see "1"

  @javascript
  Scenario: Admin should see total number of users
    Given there is a user with "zombie@brain.com" email
    And this user has the following cities in the database:
    | name | Barcelona |
    And this user has the following cities in the database:
    | name | Odessa    |
    And there is a user with "add@brain.com" email
    And this user has the following cities in the database:
    | name | Barcelona |
    And this user has the following cities in the database:
    | name | Odessa    |
    When I visit admin page
    Then I should see "2"

  @javascript
  Scenario: Admin should be able to sort users by countries_count field
    Given there is a user with "zombie@brain.com" email
    And this user has the following cities in the database:
    | name | Barcelona |
    And this user has the "created_at" field set to "2014-02-10 12:25:15 UTC"
    And there is a user with "add@brain.com" email
    And this user has the following cities in the database:
    | name | Barcelona |
    And this user has the following cities in the database:
    | name | Odessa    |
    And this user has the "created_at" field set to "2013-02-10 12:25:15 UTC"
    When I visit admin page
    And I click "Стран"
    Then I should see "add@brain.com" after "zombie@brain.com" on the page

  @javascript
  Scenario: Admin views users shared information
    Given there is a user with "zombie@brain.com" email
    And this user has the following cities in the database:
    | name | Barcelona |
    And this user has the following cities in the database:
    | name | Odessa    |
    And this user has the "shared_to" field set to "twitter"
    When I visit admin page
    Then I should see "twitter"
