Feature: Slices retrieval
  In order to draw an image
  As a user
  I want to get an image slice

  Scenario: No slices available
    Given I have no split images
    When I retrieve an image
    Then I should get a timeout error

  Scenario: With slices
    Given I have no split images
    And I ingest "q.jpg" cut in 3x1
    When I retrieve an image
    Then I should get a slice