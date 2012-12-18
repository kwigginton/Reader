module ApplicationHelper
  
  def is_logged_in?
    User.find_by_id(session[:user_id])
  end
  
  def is_admin?
    !!User.find_by_id(session[:user_id]) && User.find_by_id(session[:user_id]).is_admin?
  end

  def is_subscribed?(feed_id)
    Subscription.find_by_user_id_and_feed_id(session[:user_id], feed_id)
  end

  def title(page_title)
    content_for(:title) { page_title }
  end
end
