# encoding: UTF-8
class UserVerificationsController < ApplicationController
  def show
    @user = User.find_by_perishable_token(params[:id])
    if @user
      @user.activate! unless @user.active
      UserSession.create(@user)
      flash[:notice] = "Gracias por verificar tu email. Tu cuenta ya está activada."
      redirect_to edit_user_url @user
    else
      flash[:error] = "Cuenta no encontrada."
      redirect_to root_url
    end
  end
end