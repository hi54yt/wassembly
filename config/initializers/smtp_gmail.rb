ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :tls => true,
  :address        => APP_CONFIG['smtp_server'],
  :port           => APP_CONFIG['smtp_port'],
  :domain         => APP_CONFIG['email_domain'],
  :authentication => :plain,
  :user_name  => APP_CONFIG['email_username'],
  :password  => APP_CONFIG['email_password']
}