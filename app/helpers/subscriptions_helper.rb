module SubscriptionsHelper
  def is_subscribed?(feed_id)
    Subscription.find_by_user_id_and_feed_id(session[:user_id], feed_id)
  end
end
