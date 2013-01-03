class ReaderController < ApplicationController
  include ReaderLogic
  
  layout 'application', :only => [:index]
  
  skip_before_filter :authorize_admin, :authorize_reader, :only => [:index, :read_random, :next_random, :previous_random, :load_more]
  skip_before_filter :authorize_admin, :only => [:read_subscriptions, :next_subscription, :previous_subscription]
  
  
  
  #TODO
  #Have feeds read from random order but in a vote-weighted order
  
  def index
    render layout: 'application'
  end
  
  def read_random
    @posts = set_random_mode(params[:feed_id])
  end
  
  def read_subscriptions
    @posts = set_subscription_mode
  end
  
  def next_subscription
    @posts = get_next_subscription
    render 'read_subscriptions'
  end
  
  def previous_subscription
    @posts = get_previous_subscription
    render 'read_subscriptions'
  end
  
  def next_random
    @posts = get_next_random
    render :index

  end
  
  def previous_random
    @posts = get_previous_random
    render :index
  end
  
  def load_more
    if request.xhr?
      @posts = Post.load_entries_from_feed(params[:feed_id].to_i, params[:page].to_i)
      respond_to do |format|
        format.js{@posts}
      end
    else
      not_found
    end
    end
  
  protected
  def curr_feed
    #TODO handle error case where Feed has been deleted but Posts persist.
    if session[:read_mode] == :random
      Feed.find(session[:random_current])
    else
      has_subscriptions? ? Feed.find(session[:subscription_current]) : Feed.new(title: "No Active Subscriptions")
    end
  end
  helper_method :curr_feed
  
  #Perhaps it would be better to query the database instead of creating a Jenga tower of conditionals
  def has_subscriptions?
    !!session[:subscription_current]
  end
  helper_method :has_subscriptions?
end
