class ReaderController < ApplicationController
  include ReaderLogic
  
  skip_before_filter :authorize_admin, :authorize_reader, :only => [:index, :next_random, :previous_random]
  skip_before_filter :authorize_admin, :only => [:read_subscriptions, :next_subscription, :previous_subscription]
  #The default index action for this view leads the user to a random view of feeds from the database.
  #TODO
  #Have feeds read from random order but in a vote-weighted order
  def index
    @feed = set_random_mode
  end
  
  def read_subscriptions
    @feed = set_subscription_mode
  end
  
  def next_subscription
    @feed = get_next_subscription
    render 'read_subscriptions'
  end
  
  def previous_subscription
    @feed = get_previous_subscription
    render 'read_subscriptions'
  end
  
  def next_random
    @feed = get_next_random
    render :index

  end
  
  def previous_random
    @feed = get_previous_random
    render :index
  end
end
