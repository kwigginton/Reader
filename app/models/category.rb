class Category < ActiveRecord::Base
  attr_accessible :category_name, :supercategory_ids
  
  validates :category_name, uniqueness: true, presence: true
  
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :supercategories
  
  # All category_name values stored downcase
  # std setter method override
  def category_name=(value)
    self[:category_name] = value && value.downcase
  end
  
  #Accepts single Category as string, and Supercategory as array of Supercategories
  #TODO correct handling to  parse out and and + keywords with 
  def self.parse(cat, supercat = nil)
    if exists? category_name: cat.downcase
      return Category.find_by_category_name(cat)
    else
      newcat = create!(
        category_name: cat
      )
      newcat.supercategories = supercat
      newcat
    end
  end
end
