class Supercategory < ActiveRecord::Base
  attr_accessible :name
  
  validates :name, uniqueness: true, presence: true
  
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :feeds
  has_and_belongs_to_many :posts
end
