class AdminController < ApplicationController
  
  def index
    @total_users = User.count
    @total_feeds = Feed.count
    @total_subscriptions = Subscription.count
    @total_posts = Post.count
    @total_categories = Category.count
    @total_supercategories = Supercategory.count
    @total_votes = Vote.count
  end
end
