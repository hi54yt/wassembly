class AdminController < ApplicationController
  before_filter :only_for_admins
  
  def index
    @controllers = %w{propositions users comments logged_exceptions ratings pages announcements votes}
  end
  
  private
  
  def only_for_admins
    raise CanCan::AccessDenied unless current_user && current_user.is_admin?
  end
  
end