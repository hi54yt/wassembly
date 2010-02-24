class LoggedExceptionsController < ApplicationController
  layout "admin"
  load_and_authorize_resource
  
  def index
    @logged_exceptions = LoggedException.find_exceptions(params['page'],params)
  end
  
  def show
    @logged_exception = LoggedException.find(params[:id])
  end
  
  def destroy
    @logged_exception = LoggedException.find(params[:id])
    @logged_exception.destroy
    flash[:notice] = "Successfully destroyed logged exception."
    redirect_to logged_exceptions_url
  end
  
  def destroy_all
    LoggedException.delete_all
    redirect_to logged_exceptions_url
  end
end
