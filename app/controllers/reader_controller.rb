class ReaderController < ApplicationController
  skip_before_filter :authorize_admin, :authorize_reader, :only => [:index, :next_random, :previous_random]
  skip_before_filter :authorize_admin, :only => [:read_subscriptions, :next_subscription, :previous_subscription]
  #The default index action for this view leads the user to a random view of feeds from the database.
  #TODO
  #Have feeds read from random order but in a vote-weighted order
  def index
    #Set current read_mode to random only
    session[:read_mode] = "random"
    puts "---------setting read_Mode to #{session[:read_mode]} --------------"
    if session[:unread_random] and not session[:unread_random].empty?
      
      #pop last :unread feed id and push into :read
      session[:read_random] << session[:unread_random].last
      next_feed = Feed.find(session[:unread_random].pop)
      
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
      puts "---------you've already read--------------"
      session[:read_random].each do |id|
        puts "feed: #{id}"
      end
      puts "---------you've not yet read--------------"
      session[:unread_random].each do |id|
        puts "feed: #{id}"
      end
      
      return
    end
    
    session[:read_random] = []
    session[:unread_random] = ActiveRecord::Base.connection.select_values("select id from feeds")
    session[:unread_random].shuffle
    session[:read_random] << session[:unread_random].last
    next_feed = Feed.find(session[:unread_random].pop)
    @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
    puts "---------you've already read--------------"
    session[:read_random].each do |id|
      puts "feed: #{id}"
    end
    puts "---------you've not yet read--------------"
    session[:unread_random].each do |id|
      puts "feed: #{id}"
    end
  end
  
  def read_subscriptions
    #Set current read_mode to subscriptions only
    session[:read_mode] = "subscription"
    puts "---------setting read_Mode to #{session[:read_mode]} --------------"
    puts "---------you've already read--------------"
    session[:read].each do |id|
      puts "feed: #{id}"
    end
    puts "---------you've not yet read--------------"
    session[:unread].each do |id|
      puts "feed: #{id}"
    end
    if session[:unread] and not session[:unread].empty?
      
      #pop last :unread feed id and push into :read
      session[:read] << session[:unread].last
      next_feed = Feed.find(session[:unread].pop)
      
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
      
      return
    end
    session[:read] = []
    session[:unread] = ActiveRecord::Base.connection.select_values("select feed_id from subscriptions where user_id =#{session[:user_id]}")
    unless session[:unread].empty?
      session[:unread].shuffle
      session[:read] << session[:unread].last
      next_feed = Feed.find(session[:unread].pop)
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
      return
    else
      #TODO send feed object with one entry and title that states no subscriptions active.
      #remove logic from view
    end
  end
  
  
  def next_subscription
    if session[:unread] and not session[:unread].empty?
      
      session[:read] << session[:unread].last
      next_feed = Feed.find(session[:unread].pop)
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
    else
      
      session[:read] = []
      session[:unread] = ActiveRecord::Base.connection.select_values("select feed_id from subscriptions where user_id =#{session[:user_id]}")
      session[:unread].shuffle
      session[:read] << session[:unread].last
      next_feed = Feed.find(session[:unread].pop)
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
    end
    
    @subscription = Subscription.find_by_user_id_and_feed_id(session[:user_id], session[:read].last)
    render 'read_subscriptions'
    
    puts "-------HERE ARE YOUR VARIABLES-----"
    puts "read"
    puts session[:read]
    puts "unread"
    puts session[:unread]
    puts "-----------------------------------"
  end
  
  def previous_subscription
    
    if session[:read] and not session[:read].empty?
      
      session[:unread] << session[:read].pop
      next_feed = Feed.find(session[:unread].last)
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
    else
      
      session[:unread] = []
      session[:unread] = ActiveRecord::Base.connection.select_values("select feed_id from subscriptions where user_id =#{session[:user_id]}")
      session[:unread].shuffle
      session[:read] << session[:unread].last
      next_feed = Feed.find(session[:unread].pop)
      @feed = Feedzirra::Feed.fetch_and_parse(next_feed.feed_url)
    end
    
    render :index
    
    puts "-------HERE ARE YOUR VARIABLES-----"
    puts "read"
    puts session[:read]
    puts "unread"
    puts session[:unread]
    puts "-----------------------------------"
  end
  
  def next_random

    if session[:unread_random] and not session[:unread_random].empty?
      
      session[:read_random] << session[:unread_random].last
      next_feed = Feed.find(session[:unread_random].pop)
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
    
    puts "-------HERE ARE YOUR VARIABLES-----"
    puts "read_random"
    puts session[:read_random]
    puts "unread_random"
    puts session[:unread_random]
    puts "-----------------------------------"
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
    
    puts "-------HERE ARE YOUR VARIABLES-----"
    puts "read_random"
    puts session[:read_random]
    puts "unread_random"
    puts session[:unread_random]
    puts "-----------------------------------"
  end
  
  
end
