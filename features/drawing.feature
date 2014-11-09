@drivethrough @scalpel @gluegun @forklift
Feature: Drawing images
  In order to have fun
  As a user
  I want to draw an image

  Scenario: Drawing all slices
    Given I have no split images
    And I ingest "q.jpg" cut in 2x3
    When I draw 6 slices
    Then I should find "q.jpg" in the collages queue