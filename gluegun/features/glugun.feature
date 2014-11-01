Feature: Glue gun daemon
  In order to glue images together
  As a daemon
  I want to use the gluegun daemon

  Scenario: With all drawings
    Given I request a 200x100 collage with 1 row
    When I submit drawings 0, 1 and 2
    Then I should find a 200x100 glued image

  Scenario: With double drawings
    Given I request a 300x200 collage with 2 rows
    When I submit drawings 0, 1 and 2
    And I submit drawing 2
    And I submit drawings 3, 4, 5
    Then I should find a 300x200 glued image