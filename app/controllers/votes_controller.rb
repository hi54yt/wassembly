class VotesController < ApplicationController
  load_and_authorize_resource :nested => :proposition
  
  def index
    if @proposition
      @votes = @proposition.votes.paginate :per_page => 10, :page => params['page']
    else
       @votes = Vote.all.paginate :per_page => 10, :page => params['page']
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    @vote.user = current_user
    @vote.ip = request.remote_ip
    if @vote.save
      @proposition.reload
      respond_to do |format|
        format.js
        format.html do
          flash[:notice] = "Voto contabilizado"
          redirect_to proposition_votes_url(@proposition)
        end
      end
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @vote.update_attributes(params[:vote])
      flash[:notice] = "Successfully updated vote."
      redirect_to @proposition
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @vote.destroy
    flash[:notice] = "Successfully destroyed vote."
    redirect_to @proposition
  end
    
end
