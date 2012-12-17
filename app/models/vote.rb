class Vote < ActiveRecord::Base
  attr_accessible :user_id
  validates :user_id, presence: true
  #validates :votable_id , uniqueness: {scope: :user_id, message: " is already voted on"}
  
  belongs_to :votable, polymorphic: true
  
  
end
