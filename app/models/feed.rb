class Feed < ActiveRecord::Base
  attr_accessible :feed_url, :title, :author, :supercategory_ids
  validates :feed_url, :uniqueness => true, :presence => true
  
  has_many :subscriptions, dependent: :destroy
  has_many :posts
  has_many :users, :through => :subscriptions
  has_and_belongs_to_many :supercategories
  
  #vote relation
  #has_many :votes, as: :votable, dependent: :destroy
  
  validate do |feed|
      feed.errors.add(:base, "Looks like that's not a valid feed, or the feed is not working!") unless !!Feedzirra::Feed.fetch_and_parse(feed.feed_url)
  end
#  def ensure_not_referenced_by_any_subscription
#    if subscriptions.empty?
#      return true
#    else
#      errors.add(:base, 'Subscriptions present')
#      return false
#    end
#  end
end
