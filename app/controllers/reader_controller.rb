class ReaderController < ApplicationController
  skip_before_filter :authorize_admin, :authorize_reader, :only => [:index, :next_random, :previous_random]
  skip_before_filter :authorize_admin, :only => [:read_subscriptions, :next_subscription, :previous_subscription]
  #The default index action for this view leads the user to a random view of feeds from the database.
  #TODO
  #Have feeds read from random order but in a vote-weighted order
  def index
    #Set current read_mode to random only
    session[:read_mode] = "random"
    
    if session[:unread_random] and not session[:unread_random].empty?
      
      #pop last :unread feed id and push into :read
      session[:read_random] << session[:unread_random].last
      next_feed = Feed.find(session[:unread_random].pop)
      
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)

      return
    end
    
    session[:read_random] = []
    session[:unread_random] = ActiveRecord::Base.connection.select_values("select id from feeds")
    session[:unread_random].shuffle
    session[:read_random] << session[:unread_random].last
    next_feed = Feed.find(session[:unread_random].pop)
    @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)

  end
  
  #ALL of this unnecessary database polling could be eliminated with an extra session variable, but for now I will leave it be.
  
  def read_subscriptions
    #Set current read_mode to subscriptions only
    session[:read_mode] = "subscriptions"
    
    if session[:unread_subscriptions] and not session[:unread_subscriptions].empty?
      
      #pop last :unread feed id and push into :read
      session[:read_subscriptions] << session[:unread_subscriptions].last
      next_feed = Feed.find(Subscription.find(session[:unread_subscriptions].pop).feed_id)
      
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
      
      return
    end
    session[:read_subscriptions] = []
    session[:unread_subscriptions] = ActiveRecord::Base.connection.select_values("select id from subscriptions where user_id =#{session[:user_id]}")
    unless session[:unread_subscriptions].empty?
      session[:unread_subscriptions].shuffle
      session[:read_subscriptions] << session[:unread_subscriptions].last
      next_feed = Feed.find(Subscription.find(session[:unread_subscriptions].pop).feed_id)
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
      return
    else
      #TODO send feed object with one entry and title that states no subscriptions active.
      #remove logic from view
    end
  end
  
  
  def next_subscription
    if session[:unread_subscriptions] and not session[:unread_subscriptions].empty?
      
      session[:read_subscriptions] << session[:unread_subscriptions].last
      next_feed = Feed.find(Subscription.find(session[:unread_subscriptions].pop).feed_id)
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
    else
      
      session[:read_subscriptions] = []
      session[:unread_subscriptions] = ActiveRecord::Base.connection.select_values("select id from subscriptions where user_id =#{session[:user_id]}")
      session[:unread_subscriptions].shuffle
      session[:read_subscriptions] << session[:unread_subscriptions].last
      next_feed = Feed.find(Subscription.find(session[:unread_subscriptions].pop).feed_id)
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
    end
    
    @subscription = Subscription.find(session[:read_subscriptions].last)
    render 'read_subscriptions'
    
  end
  
  def previous_subscription
    
    if session[:read_subscriptions] and not session[:read_subscriptions].empty?
      
      session[:unread_subscriptions] << session[:read_subscriptions].pop
      next_feed = Feed.find(Subscription.find(session[:unread_subscriptions].last).feed_id)
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
    else
      
      session[:unread_subscriptions] = []
      session[:unread_subscriptions] = ActiveRecord::Base.connection.select_values("select id from subscriptions where user_id =#{session[:user_id]}")
      session[:unread_subscriptions].shuffle
      session[:read_subscriptions] << session[:unread_subscriptions].last
      next_feed = Feed.find(Subscription.find(session[:unread_subscriptions].pop).feed_id)
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
    end
    
    render :index
    
  end
  
  def next_random
    
    #if user is already reading
    if session[:unread_random] and not session[:unread_random].empty?
      #Load the next unread feed and parse to view.
      session[:read_random] << session[:unread_random].last
      next_feed = Feed.find(session[:unread_random].pop)
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
    else
      #if user is just starting reading, init vars and fill with all feed ids in random order.
      session[:read_random] = []
      session[:unread_random] = ActiveRecord::Base.connection.select_values("select id from feeds")
      session[:unread_random].shuffle
      session[:read_random] << session[:unread_random].last
      next_feed = Feed.find(session[:unread_random].pop)
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
    end
    
    render :index

  end
  
  def previous_random

    if session[:read_random] and not session[:read_random].size <= 1
      
      session[:unread_random] << session[:read_random].pop
      next_feed = Feed.find(session[:read_random].last)
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
    else
      
      session[:read_random] = []
      session[:unread_random] = ActiveRecord::Base.connection.select_values("select id from feeds")
      session[:unread_random].shuffle
      session[:read_random] << session[:unread_random].last
      next_feed = Feed.find(session[:unread_random].pop)
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
    end
    
    render :index
    
  end
  
  
end
