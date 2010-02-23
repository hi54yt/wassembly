class IdentityVerificationsController < ApplicationController
  include Tractis::IdentityVerifications
  
  def create
    unauthorized! if current_user.nil?
    @user = current_user
    valid_tractis_identity_verification!(APP_CONFIG['tractis_api_key'], params)
    @user.eid = params["tractis:attribute:dni"]
    @user.identity_verified = true unless params["tractis:attribute:dni"].blank?
    if @user.save
      flash[:notice] = "Identidad verificada"
      redirect_to edit_user_url(@user)
    else
      flash[:error] = "Error en la identificación:<br/> #{@user.errors.full_messages.join('<br/>')}" 
      redirect_to edit_user_url(@user)
    end
    rescue Tractis::InvalidVerificationError
      flash[:error] = "Falló la verificación de identidad"
      redirect_to root_url
  end
end
