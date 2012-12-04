class User < ActiveRecord::Base
  
  after_initialize :init
  
  attr_accessible :password, :password_confirmation, :role, :email

  validates :email, presence: true, format: { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }, uniqueness: {message: " is already in use."}
  
  has_many :feeds, through: :subscriptions
  
  has_many :subscriptions, dependent: :destroy
  
  #vote relationship
  has_and_belongs_to_many :feeds
  has_and_belongs_to_many :posts
  
  has_secure_password
  
  def init
    self.role ||= 'reader'
  end
  
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
  def email=(value)
    self[:email] = value && value.downcase
  end
  
end
