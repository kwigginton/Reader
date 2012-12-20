module ReaderLogic
  
  #Sets reading_mode to random, instantiates the session variable 
  # => containing random feed ids to read if not already set, and
  # => shuffles them
  def set_random_mode(def_feed = nil, cat = nil)
    
    session[:read_mode] = :random
    
    unless session[:random_feeds] and not session[:random_feeds].empty? and session[:random_current]
      #Grab, randomize, and convert to int: all feed IDs
      session[:random_feeds] = ActiveRecord::Base.connection.select_values("select id from feeds").shuffle.collect{|s| s.to_i}
    end
    session[:random_current] = !!def_feed ? Feed.find(def_feed).id.to_i : session[:random_feeds].first
    return Post.load_entries_from_feed(session[:random_current], 0)
  end

  #Sets reading_mode to subscription, instantiates the session variable 
  # => containing subscribed feed ids to read if not already set, and
  # => preserves orderr
  def set_subscription_mode(def_feed = nil)
    
    session[:read_mode] = :subscription
    
    if session[:subscription_feeds] and not session[:subscription_feeds].empty? and session[:subscription_current]
      #if user has just added a feed, or specified a feed, direct them there!
      if(def_feed)
        session[:subscription_current] = Feed.find(def_feed).id.to_i
      end
    else
      #Grab and convert to int: all feed IDs
      session[:subscription_feeds] = ActiveRecord::Base.connection.select_values("select feed_id from subscriptions where user_id =#{session[:user_id]}").collect{|s| s.to_i}
      session[:subscription_current] = session[:subscription_feeds].first
    end
    return session[:subscription_feeds].empty? ? no_subscriptions : Post.load_entries_from_feed(session[:subscription_current], 0)
  end
  
  def get_next_random(def_feed = nil)
    unless session[:random_feeds]
      return set_random_mode(def_feed)
    end
    
    session[:read_mode] = :random
    #implement circular browsing flow
    if(session[:random_current] == session[:random_feeds].last)
      session[:random_current] = session[:random_feeds].first
    else
      #Read literally as:          the next feed_id in random_feeds after current feed 
      session[:random_current] = session[:random_feeds][session[:random_feeds].index(session[:random_current]) + 1]
    end
    
    return Post.load_entries_from_feed(session[:random_current], 0)
  end
  
  def get_previous_random(def_feed = nil)
    unless session[:random_feeds]
      return set_random_mode(def_feed)
    end
    
    session[:read_mode] = :random
    #implement circular browsing flow
    if(session[:random_current] == session[:random_feeds].first)
      session[:random_current] = session[:random_feeds].last
    else
      #Read literally as:          the previous feed_id in random_feeds before current random feed
      session[:random_current] = session[:random_feeds][session[:random_feeds].index(session[:random_current]) - 1]
    end
    
    return Post.load_entries_from_feed(session[:random_current], 0)
  end
  
  def get_next_subscription(def_feed = nil)

    if not !!session[:subscription_feeds] or session[:subscription_feeds].empty?
      return set_subscription_mode(def_feed)
    end
    
    session[:read_mode] = :subscription
    #implement circular browsing flow
    if(session[:subscription_current] == session[:subscription_feeds].last)
        session[:subscription_current] = session[:subscription_feeds].first
    else
        #Read literally as: the next feed_id in subscription_feeds after current subscribed feed
        session[:subscription_current] = session[:subscription_feeds][session[:subscription_feeds].index(session[:subscription_current]) + 1]
    end

    return Post.load_entries_from_feed(session[:subscription_current], 0)
  end
  
  def get_previous_subscription(def_feed = nil)

    if not !!session[:subscription_feeds] or session[:subscription_feeds].empty?
      return set_subscription_mode(def_feed)
    end
    
    session[:read_mode] = :subscription
    #implement circular browsing flow
    if(session[:subscription_current] == session[:subscription_feeds].first)
      session[:subscription_current] = session[:subscription_feeds].last
    else
      #Read literally as:          the previous feed_id in subscription_feeds before current subscribed feed
      session[:subscription_current] = session[:subscription_feeds][session[:subscription_feeds].index(session[:subscription_current]) - 1]
    end
    return Post.load_entries_from_feed(session[:subscription_current], 0)
  end
  
  #Feed object filled with data for when a user has no subscriptions.
  def no_subscriptions
    errPost = Post.new
    errPost.title = "No Subscriptions!"
    errPost.author = ""
    #TODO remove hardcoding for explore link
    errPost.summary = errPost.content = "You have no active subscriptions, go <a href='/explore'>explore</a> and find something new and awesome that you connect with!".html_safe
    #TODO change Time.now to PST zone
    errPost.published_at = Time.now
    Array[errPost]
  end
  
  #Feed object filled with data for an erroneous RSS feed
  def error_feed
    errPost = Feedzirra::Parser::RSS.new
    errPost.title = "Error"
    errPost.entries = [Feedzirra::Parser::RSSEntry.new]
    #TODO change Time.now to PST zone
    errPost.entries.first.published = Time.now.to_s
    errPost.entries.first.title = "Sorry! We can't find this feed!"
    errPost.entries.first.content = errPost.entries.first.summary = "This feed is giving us an error, we will check into it!"
    Array[errPost]
  end
end