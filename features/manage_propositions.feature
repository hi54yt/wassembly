Feature: Manage Propositions
  In order propose propositions
  As a user logged in as paco
  I want to create and view propositions
  
  Scenario: Latest Propositions List
	Given the following propositions exist
	      | title               | state    | body           | interest |
	      | Lorem Ipsum         | proposed | dolor sit amet | 1        |
	      | Other proposition   | proposed | More words     | 1        |
	      | Proposition to vote | to_vote  | something      | 1000     |
	When I go to path "/propositions/latest"
	Then I should see "Lorem Ipsum"
	And I should see "Other proposition"
	And I should not see "Proposition to vote" within "#propositions_list"