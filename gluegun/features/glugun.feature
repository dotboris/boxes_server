Feature: Glue gun daemon
  In order to glue images together
  As a daemon
  I want to use the gluegun daemon

  Scenario: With all drawings
    Given I request a 200x100 collage cut in 2x1
    When I submit 100x100 drawings "0, 1, 2"
    Then I should find a 200x100 glued image

  Scenario: With double drawings
    Given I request a 300x200 collage cut in 2x3
    When I submit 100x100 drawings "0, 1, 2"
    And I submit 100x100 drawing "2"
    And I submit 100x100 drawings "3, 4, 5"
    Then I should find a 300x200 glued image