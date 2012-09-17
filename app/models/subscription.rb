class Subscription < ActiveRecord::Base
  # TODO
  # make message handling so that "Feed" does not predicate the message
  attr_accessible :user_id, :feed_id
  
  validates :feed_id, :presence => true, :uniqueness => {:scope => :user_id, :message => " is already in your subscriptions"}
  validates  :user_id, :presence => true
  belongs_to :feed
  belongs_to :user
end
