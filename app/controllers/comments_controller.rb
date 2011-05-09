# encoding: UTF-8
class CommentsController < ApplicationController
  load_resource :proposition
  load_and_authorize_resource :comment, :through => :proposition
  
  def index
    @comments = Comment.all.paginate :per_page => 10, :page => params['page'], :order => 'created_at DESC'
  end
  
  def show
  end
  
  def create
    @comment = @proposition.comments.build(params[:comment])
    @comment.ip = request.remote_ip
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "Comentario guardado con éxito"
    end
    redirect_to @proposition
  end
  
  def edit
  end
  
  def update
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to @proposition
    else
      render 'edit'
    end
  end
  
  def destroy
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to @proposition
  end
end
