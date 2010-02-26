Feature: Register new user 
  In order register new users
  As a guest
  I want to create a new account
  
  Scenario: Create account with email and password
	Given I am on the sign up page
	When I fill in the following:
	 | user_username              | paquito              |
	 | user_email                 | pacopico@example.com |
	 | user_password              | secret               |
	 | user_password_confirmation | secret               |
	And I press "Guardar"
	Then I should see "Registro completado!"
	And I should see "Hemos enviado un email a tu dirección de correo para validar que es correcta."
	And an email should be sent to pacopico@example.com