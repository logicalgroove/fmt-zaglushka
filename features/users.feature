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
    And I search google maps for "Barcelona" city
    And I wait for ajax request to finish
    And I search google maps for "Odessa" city
    And I wait for ajax request to finish
    Then this user should see "2" cities as travelled cities
    Then this user should have "Barcelona" as travelled cities
    And I should see the following city in the database:
    | name      | Barcelona |
    | latitude  | 11        |
    | longitude | 22        |
    | g_id      | 33        |

  @javascript
  Scenario: City should be unique in the database
    Given I exist as a user
    When I visit my user page
    And I search google maps for "Barcelona" city
    And I wait for ajax request to finish
    And I search google maps for "Barcelona" city
    And I wait for ajax request to finish
    And should be only one "Barcelona" in database
    And I should have "Barcelona" as unique city in my travelled cities

