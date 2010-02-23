class Notifier < ActionMailer::Base
  
  default_url_options[:host] = "wasamblea.org"  

  def verification_instructions(user)
    subject       "Wasamblea - Comprobación de correo electrónico"
    from          "admin@wasamblea.org"
    recipients    user.email
    sent_on       Time.now
    body          :verification_url => user_verification_url(user.perishable_token)
  end

end
