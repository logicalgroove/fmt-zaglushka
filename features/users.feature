Feature: User enter email

  Background:
    Given there are some cities in the database

  @javascript
  Scenario: User email is stored
    When I visit home page
    When I click "Запросить инвайт"
    And I wait for 3 seconds
    And I fill in "Email" with "user@mail.com"
    And I press "Получить инвайт"
    Then I should see "Спасибо"

  @javascript
  Scenario: User add a city
    Given I exist as a user
    When I visit my user page
    And I fill in "Город" with "Barcelona"
    And I press "Сохранить"
    And I wait for ajax request to finish
    Then this user should have "Barcelona" as travelled cities
