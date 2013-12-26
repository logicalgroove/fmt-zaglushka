Feature: User enter email

  @javascript
  Scenario: User email is stored
    When I visit home page
    And I click "Запросить инвайт"
    And I wait for 3 seconds
    And I click "Запросить инвайт"
    And I fill in "Твой email:" with "user@mail.com"
    And I press "Получить инвайт"
    Then I should see "Спасибо!"

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
  Scenario: City and country should be unique in the database
    Given I exist as a user
    When I visit my user page
    And I search google maps for "Barcelona, Spain"
    And I wait for ajax request to finish
    And I search google maps for "Barcelona, Spain"
    And I wait for ajax request to finish
    And I search google maps for "Barcelona, Spain"
    And I wait for ajax request to finish
    Then "city_name_auto" field should display an error
    And should be only one city "Barcelona" in database
    And should be only one country "Spain" in database
    And I should have "Barcelona" as unique city in my travelled cities
    And I should have "Spain" as unique country in my travelled countries
    And I should see "1" country on my page
    And I should see "1" city on my page

  @javascript
  Scenario: User should get error message when enters invalid email
    When I visit home page
    And I click "Запросить инвайт"
    And I wait for 3 seconds
    And I click "Запросить инвайт"
    And I fill in "Твой email:" with "user.gmail.com"
    And I press "Получить инвайт"
    And I wait for ajax request to finish
    Then I should not see the following user in the database:
     | email | user.gmail.com |
    And "user_email" field should display an error

  @javascript
  Scenario: User should get error message if email is already taken
    Given I exist as a user
    When I visit home page
    And I click "Запросить инвайт"
    And I wait for 3 seconds
    And I click "Запросить инвайт"
    And I fill in "Твой email:" with "user@g.com"
    And I press "Получить инвайт"
    And I wait for ajax request to finish
    Then "user_email" field should display an error

  @javascript
  Scenario: User creates multiple cities and countries
    Given I exist as a user
    When I visit my user page
    And I search google maps for "Barcelona, Spain"
    And I wait for ajax request to finish
    And I search google maps for "Odessa, Ukraine"
    And I wait for ajax request to finish
    And I search google maps for "Kiev, Ukraine"
    And I wait for ajax request to finish
    And I search google maps for "Moscow, Russia"
    And I wait for ajax request to finish
    And I search google maps for "Habana, Cuba"
    And I wait for ajax request to finish
    Then I should have "5" cities as travelled cities
    And I should have "4" countries as travelled countries

  @javascript @email
  Scenario: User get email after registration
    When I visit home page
    And I click "Запросить инвайт"
    And I wait for 3 seconds
    And I click "Запросить инвайт"
    And I fill in "Твой email:" with "user@mail.com"
    And I press "Получить инвайт"
    Then I should see "Спасибо"
    And I should see an "Registered" e-mail

  @javascript
  Scenario: Not valid user should be able to view users page without editing it
    Given there is a user with "zombie@brain.com" email
    And this user has the following cities in the database:
    | name | Barcelona |
    And this user has the following cities in the database:
    | name | Odessa    |
    When I exist as a user
    And I visit "zombie@brain.com" page
    Then I should not see "Спасибо"

  @javascript @email
  Scenario: User should not be able to register same email using different case letters
    Given I exist as a user
    When I visit home page
    And I click "Запросить инвайт"
    And I wait for 3 seconds
    And I click "Запросить инвайт"
    And I fill in "Твой email:" with "user@g.com"
    And I press "Получить инвайт"
    And I wait for ajax request to finish
    And I visit home page
    And I click "Запросить инвайт"
    And I wait for 3 seconds
    And I click "Запросить инвайт"
    And I fill in "Твой email:" with "uSer@G.com"
    And I press "Получить инвайт"
    And I wait for ajax request to finish
    Then "user_email" field should display an error

  @javascript
  Scenario: Visitor becomes a user
    Given there is a user with "zombie@brain.com" email
    When I exist as a user
    And I visit "zombie@brain.com" page
    And I click "Стань участником!"
    And I fill in "Твой email:" with "user@g.ru"
    And I press "Получить инвайт"
    And I wait for ajax request to finish
    Then I should see "Спасибо"

