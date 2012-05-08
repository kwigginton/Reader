class Feed < ActiveRecord::Base
  
  validates :feed_url, uniqueness: true, presence: true
  
  has_many :users, :through => :subscriptions
  
  before_destroy :ensure_not_referenced_by_any_subscription
  
  def ensure_not_referenced_by_any_subscription
    if subscriptions.empty?
      return true
    else
      errors.add(:base, 'Subscriptions present')
      return false
    end
  end
end
