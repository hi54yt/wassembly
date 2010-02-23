# coding: utf-8
class UserSessionsController < ApplicationController
  def new
    if current_user_session
      flash[:error] = "Ya has iniciado sesión."
      redirect_to root_url
    end
    @user_session = UserSession.new
  end
  
  def create
    current_user_session.destroy if current_user_session
    
    if params[:user_session] && !params[:user_session][:openid_identifier].blank?
      params[:user_session].delete :password
      params[:user_session].delete :email
    end
      
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
      if result
        flash[:notice] = "Inicio de sesión correcto!"
        redirect_to root_url
      else
        flash[:error] = "e-mail o contraseña inválidos"
        render :action => 'new'
      end
    end
  end
  
  def destroy
    @user_session = current_user_session
    @user_session.destroy
    flash[:notice] = "Sesión finalizada"
    redirect_to root_url
  end

end
