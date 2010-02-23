Feature: Manage Propositions
  In order propose propositions
  As a user logged in as paco
  I want to create and view propositions
  
  Scenario: Latest Propositions List
	Given the following propositions exist
	      | title               | state    | body           |
	      | Lorem Ipsum         | proposed | dolor sit amet |
	      | Other proposition   | proposed | More words     |
	      | Proposition to vote | to_vote  | something      |
	When I go to path "/propositions/latest"
	Then I should see "Lorem Ipsum"
	And I should see "Other proposition"
	And I should not see "Proposition to vote"