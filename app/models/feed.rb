class Feed < ActiveRecord::Base
  
  validates :feed_url, uniqueness: true, presence: true
  
  has_many :subscriptions
  has_many :users, :through => :subscriptions
  
#  def ensure_not_referenced_by_any_subscription
#    if subscriptions.empty?
#      return true
#    else
#      errors.add(:base, 'Subscriptions present')
#      return false
#    end
#  end
end
