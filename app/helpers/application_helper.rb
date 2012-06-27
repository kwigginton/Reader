module ApplicationHelper
  
  def is_logged_in?
    User.find_by_id(session[:user_id])
  end
  
  def is_admin?
    User.find_by_id(session[:user_id]).is_admin?
  end
  
  def welcome_uri
    welcome_url
  end
  def is_subscribed?(feed_id)
    Subscription.find_by_user_id_and_feed_id(session[:user_id], feed_id)
  end

end
