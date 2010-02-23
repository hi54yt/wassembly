# coding: utf-8
class UserSession < Authlogic::Session::Base
  find_by_login_method :find_by_email

  private
  
  def self.find_by_email(login)
    User.find_by_email(login)
  end
end