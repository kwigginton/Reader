module ApplicationHelper
  
  def is_logged_in?
    User.find_by_id(session[:user_id])
  end
  
end
