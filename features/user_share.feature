Feature: User shares map
  Background:
    Given I exist as a user
    When I visit my user page
    And I wait for 8 seconds
    And I search google maps for "Barcelona, Spain"
    And I wait for ajax request to finish

  @javascript
  Scenario: System saves facebook sharing information if user click facebook
    When I refresh the page
    And I wait for 8 seconds
    And I click "Моя карта готова"
    And I click "share_to-facebook"
    And I wait for ajax request to finish
    Then I should have "facebook" as shared option

  @javascript
  Scenario: System saves instagram sharing information if user click instagram
    Given I visit page from mobile device
    And I click "Моя карта готова"
    And I wait for 8 seconds
    And I click "share_to-instagram"
    And I wait for ajax request to finish
    Then I should have "instagram" as shared option
    And I should see "Сохрани эту фотографию для Instagram:"

  @javascript
  Scenario: System saves twitter sharing information if user click twitter
    When I refresh the page
    And I wait for 8 seconds
    And I click "Моя карта готова"
    And I click "share_to-twitter"
    And I wait for ajax request to finish
    Then I should have "twitter" as shared option

  @javascript
  Scenario: System saves vk sharing information if user click vk
    When I refresh the page
    And I wait for 8 seconds
    And I click "Моя карта готова"
    And I click "share_to-vk"
    And I wait for ajax request to finish
    Then I should have "vk" as shared option
