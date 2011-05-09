# encoding: UTF-8
class RatingsController < ApplicationController
  layout "admin"
  load_resource :proposition
  authorize_resource :rating
  
  def index
    if @proposition
      @ratings = @proposition.ratings.paginate :per_page => 20, :page => params['page'], :order => 'created_at ASC'
    else
      @ratings = Rating.paginate :per_page => 20, :page => params['page'], :order => 'created_at ASC'
    end
  end
  
  def show
    @rating = Rating.find(params[:id])
  end
  
  def new
    @rating = Rating.new(params[:rating])
  end
  
  def create
    @rating = Rating.new(params[:rating])
    @rating.rater_id = current_user.id
    @rating.ip = request.remote_ip
   
    if @rating.save
      @rating.rateable.reload
      respond_to do |format|
        format.js 
        format.html do
          flash[:notice] = "Valoración guardada"
          rateable = (@rating.rateable.respond_to? :proposition) ? @rating.rateable.proposition : @rating.rateable
          redirect_to rateable
        end
      end
    else
      render 'new'
    end
  end
  
  def edit
    @rating = Rating.find(params[:id])
  end
  
  def update
    @rating = Rating.find(params[:id])
    if @rating.update_attributes(params[:rating])
      flash[:notice] = "Successfully updated rating."
      redirect_to @rating
    else
      render 'edit'
    end
  end
  
  def destroy
    @rating = Rating.find(params[:id])
    @rating.destroy
    flash[:notice] = "Successfully destroyed rating."
    redirect_to ratings_url
  end  
end
