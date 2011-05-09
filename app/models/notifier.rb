# encoding: UTF-8
class Notifier < ActionMailer::Base
  
  default_url_options[:host] = "wasamblea.org"  

  def verification_instructions(user)
    @user = user
    
    mail :to => user.email,
         :from => "admin@wasamblea.org",
         :subject => "Wasamblea - Comprobación de correo electrónico"
  end

end
