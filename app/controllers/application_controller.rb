class ApplicationController < ActionController::Base
  before_filter :authorize_reader, :authorize_admin, :prepare_for_mobile
  protect_from_forgery
  
  private
  
  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end
  
  def current_user
    User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    redirect_to welcome_url, :notice => "You must log in to access user actions"
  end
  helper_method :current_user
  
  def admin?
    current_user.is_admin?
  end
  helper_method :admin?
  
  def mobile_device?
    if session[:mobile_param] 
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  helper_method :mobile_device?
  
  def parse_categories(catStr)
   #TODO return an array of category strings
  end
  
  protected
  
  def authorize_admin
    unless admin?
      session[:return_to] = request.url
      redirect_to login_url, :notice => "Please log in."
    end
  end
  
#  def authorize
#    unless User.find_by_id(session[:user_id])
#      redirect_to login_url, notice: "Please log in"
#    end
# end
  
  def authorize_reader
    unless User.is_reader(session[:user_id]) || admin?
      puts "\n\n\n\n\n"
      puts request.url
      puts "\n\n\n\n\n"
      session[:return_to] = request.url
      redirect_to login_url, :notice => "Please log in"
    end
  end

    
end
