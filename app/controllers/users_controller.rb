class UsersController < ApplicationController
  load_and_authorize_resource
  
  def index
    @users = User.paginate :per_page => 10, :page => params['page'], :order => 'created_at DESC'
  end
  
  def show
  end
  
  def new
  end
  
  def edit
  end
  
  def create
    if @user.openid_identifier || params['openid.sig']
      register_with_openid
    else
      register_without_openid
    end
  end

  def update
    @user.attributes = params[:user]
    @user.save do |result|
      if result
        flash[:notice] = t 'flash.notice.profile_updated'
        redirect_to edit_user_url(@user)
      else
        render :action => 'edit'
      end
    end
  end
  
  private
  
  def register_with_openid
    @user.save do |result|
      if result
        flash[:notice] = t 'flash.notice.registration_completed'
         redirect_to edit_user_url @user
      else
        render :action => 'new'
      end
    end
  end
  
  def register_without_openid
    @user.active = false
    if @user.save_without_session_maintenance 
      flash[:notice] = "#{t 'flash.notice.registration_completed'} #{t 'flash.notice.email_sent' }" 
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
end
