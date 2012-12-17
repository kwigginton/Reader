class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :category_name

      t.timestamps
    end
    #join table
    create_table :categories_posts, :id => false do |t|
      t.integer :category_id
      t.integer :post_id
    end
    create_table :categories_feeds, :id => false do |t|
      t.integer :category_id
      t.integer :feed_id
    end
  end
end
