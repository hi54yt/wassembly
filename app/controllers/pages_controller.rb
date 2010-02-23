# encoding: utf-8 
class PagesController < ApplicationController
  
  before_filter :find_page_by_permalink, :only => :show
  load_and_authorize_resource
  
  def index
    @pages = Page.all
  end
  
  def show
  end
  
  def new
    @page = Page.new
  end
  
  def create
    @page = Page.new(params[:page])
    if @page.save
      flash[:notice] = "Successfully created page."
      redirect_to @page
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @page.update_attributes(params[:page])
      flash[:notice] = "Successfully updated page."
      redirect_to @page
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @page.destroy
    flash[:notice] = "Successfully destroyed page."
    redirect_to pages_url
  end
  
  private

  def find_page_by_permalink
    if params[:permalink]
        @page = Page.find_by_permalink(params[:permalink])
        raise ActiveRecord::RecordNotFound, "Página no encontrada" if @page.nil?
    else
        @page = Page.find(params[:id])
    end
  end
end
