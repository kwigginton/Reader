class User < ActiveRecord::Base
  
  attr_accessible :username, :password, :password_confirmation, :role, :email
  
  validates :username, :presence => true, :uniqueness => true
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  
  has_many :feeds, :through => :subscriptions, :dependent => :destroy
  
  has_many :subscriptions
  
  has_secure_password
  
  def self.admin
    'admin'
  end
  
  def self.reader
    'reader'
  end
  
  def self.is_admin(user_id)
    user = User.find_by_id(user_id)
    user.role == User.admin if(user) 
  end
  
  def is_admin?
    self.role == User.admin
  end
  
  def is_reader?
    self.role == User.reader
  end
  
  def self.is_reader(user_id)
    if user = User.find_by_id(user_id)
      role = user.role
      role == User.reader || role == User.admin
    end
  end

  def is_subscribed?(feed_url)
    !!Subscription.find_by_user_id_and_feed_id(self[ :id ], Feed.find_by_feed_url(feed_url))
  end
    
  # All usernames and emails will be stored lowercase to avoid issues with postgres or other annoying dbs.
  def username=(value)
    self[:username] = value && value.downcase
  end
  
  def email=(value)
    self[:email] = value && value.downcase
  end
end
