class ApplicationController < ActionController::Base
  before_filter :authorize_reader, :authorize_admin
  protect_from_forgery
  
  
  protected
  
  def authorize_admin
    unless User.is_admin(session[:user_id])
      redirect_to login_url, notice: "Please log in."
    end
  end
  
#  def authorize
#    unless User.find_by_id(session[:user_id])
#      redirect_to login_url, notice: "Please log in"
#    end
# end
  
  def authorize_reader
    unless User.is_reader(session[:user_id])
      redirect_to login_url, notice: "Please log in"
    end
  end
end
