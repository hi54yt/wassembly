# coding: utf-8
class PropositionsController < ApplicationController
  load_and_authorize_resource
  
  caches_action :voting, :if => :guest_user?, :expires_in => 5.minutes, :cache_path => Proc.new { |c| c.request.url }
  caches_action :latest, :if => :guest_user?, :expires_in => 2.minutes, :cache_path => Proc.new { |c| c.request.url }
  caches_action :show, :if => :guest_user?, :expires_in => 2.minutes, :cache_path => Proc.new { |c| c.request.url }
  
  def index
    @propositions = Proposition.paginate :per_page => 5, :page => params['page'], :order => 'created_at DESC'
  end
  
  def show
    @comments = @proposition.comments.paginate :per_page => 20, :page => params['page'], :order => 'created_at ASC', :include => :user
  end
  
  def new
  end
  
  def create
    @proposition.user = current_user
    @proposition.ip = request.remote_ip
    @proposition.state = 'proposed' 
    if @proposition.save
      flash[:notice] = t 'flash.notice.create_proposition_success'
      redirect_to @proposition
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @proposition.update_attributes(params[:proposition])
      flash[:notice] = "Successfully updated proposition."
      redirect_to @proposition
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @proposition.destroy
    flash[:notice] = "Successfully destroyed proposition."
    redirect_to propositions_url
  end
  
  #Custom propositions actions
  def latest
    @title = "Últimas propuestas"
    @propositions = Proposition.latest_proposed.includes(:users).paginate :per_page => 10, :page => params['page']
    render :action => 'index'
  end
  
  def voting
    @title = "Propuestas a votación"
    @propositions = Proposition.to_vote.includes(:users).paginate :per_page => 10, :page => params['page']
    render :action => 'index'
  end
end
