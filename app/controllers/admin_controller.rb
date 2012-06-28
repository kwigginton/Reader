class AdminController < ApplicationController
  
  def index
    @total_users = User.count
    @total_feeds = Feed.count
    @total_subscriptions = Subscription.count
  end
end
