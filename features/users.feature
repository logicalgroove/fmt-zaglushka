Feature: User enter email

  @javascript
  Scenario: User email is stored
    When I visit home page
    When I click "Запросить инвайт"
    And I wait for 3 seconds
    And I fill in "Твой email:" with "user@mail.com"
    And I press "Получить инвайт"
    Then I should see "Спасибо"

  @javascript
  Scenario: User add a city
    Given I exist as a user
    When I visit my user page
    And I search google maps for "Barcelona, Spain"
    And I wait for ajax request to finish
    And I search google maps for "Odessa, Ukraine"
    And I wait for ajax request to finish
    Then I should have "2" cities as travelled cities
    Then I should have "Barcelona" as travelled cities
    And I should see the following city in the database:
    | name      | Barcelona |
    | latitude  | 11        |
    | longitude | 22        |
    | g_id      | 33        |
    And I should see the following country in the database:
    | name | Spain |


  @javascript
  Scenario: City should be unique in the database
    Given I exist as a user
    When I visit my user page
    And I search google maps for "Barcelona, Spain"
    And I wait for ajax request to finish
    And I search google maps for "Barcelona, Spain"
    And I wait for ajax request to finish
    And I search google maps for "Barcelona, Spain"
    And I wait for ajax request to finish
    And should be only one "Barcelona" in database
    And I should have "Barcelona" as unique city in my travelled cities
    And should be only one "Barcelona" on the page
