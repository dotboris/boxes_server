Feature: Clerk daemon
  In order to ingest images into the gallery
  As a daemon
  I want to use the clark daemon

  Scenario: Ingestion
    When I ingest "q.jpg"
    Then I should find "q.jpg" in mongodb