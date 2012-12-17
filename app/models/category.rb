class Category < ActiveRecord::Base
  attr_accessible :category_name, :supercategory_ids
  
  validates :category_name, uniqueness: true, presence: true
  
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :supercategories
  
  # All category_name values stored downcase
  def category_name=(value)
    self[:category_name] = value && value.downcase
  end
  
  #Accepts only a single category string
  #TODO correct handling to  parse out and and + keywords with 
  def self.parse(cat)
    if exists? category_name: cat.downcase
      return Category.find_by_category_name(cat)
    else
      create!(
        category_name: cat
      )
    end
  end
end
