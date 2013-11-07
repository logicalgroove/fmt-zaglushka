Feature: User enter email

  Background:
    Given there are some cities in the database

  Scenario: User email is stored
    When I click "Запросить инвайт"
    And I fill in "email" with "user@mail.com"
    And I press "Получить инвайт"
    Then I should see "Спасибо"
