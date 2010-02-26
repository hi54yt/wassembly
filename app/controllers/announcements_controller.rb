class AnnouncementsController < ApplicationController
  load_and_authorize_resource :except => 'hide'

  def hide
    session[:announcement_hide_time] = Time.now
    respond_to do |format|
      format.js
      format.html { redirect_to :back}
    end
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end

  def index
    @announcements = Announcement.paginate :per_page => 10, :page => params['page'], :order => 'created_at DESC'
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @announcement.save
      flash[:notice] = 'Announcement was successfully created.'
      redirect_to(@announcement)
    else
      render :action => "new"
    end
  end

  def update
    if @announcement.update_attributes(params[:announcement])
      flash[:notice] = 'Announcement was successfully updated.'
      redirect_to(@announcement)
    else
      render :action => "edit"
    end
  end

  def destroy
    @announcement.destroy
    redirect_to(announcements_url)
  end
end
