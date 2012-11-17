class Feed < ActiveRecord::Base
  attr_accessible :feed_url, :title, :author, :feed_data
  validates :feed_url, :uniqueness => true, :presence => true
  
  has_many :subscriptions, dependent: :destroy
  has_many :users, :through => :subscriptions
  
  serialize :feed_data
  
  validate do |feed|
      feed.errors.add(:base, "Looks like that's not a valid feed, or the feed is not working!") unless !!feed.feed_data
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
