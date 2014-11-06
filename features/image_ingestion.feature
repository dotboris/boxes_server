@scalpel
Feature: Image ingestion
  In order to add pictures to Boxes
  As an administrator
  I want to ingest images

  Scenario: Ingesting an image
    Given I have no split images
    When I ingest "mccoy.jpg" cut in 3x2
    Then I should see 1 active split image
    And I should see a split image with 6 slices
    And I should see a split image with a row_count of 3
    And I should see a split image with a width of 461
    And I should see a split image with a height of 600