class AdminController < ApplicationController
  before_filter :only_for_admins
  
  def index
    @controllers = ActionController::Routing.possible_controllers - %w{rails/info rails_info admin application user_sessions user_verifications identity_verifications}
  end
  
  private
  
  def only_for_admins
    unauthorized! unless current_user && current_user.is_admin?
  end
  
end