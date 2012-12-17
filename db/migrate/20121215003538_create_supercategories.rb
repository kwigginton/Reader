class CreateSupercategories < ActiveRecord::Migration
  def change
    create_table :supercategories do |t|
      t.string :name

      t.timestamps
    end
    create_table :categories_supercategories, id: false do |t|
      t.integer :category_id
      t.integer :supercategory_id
    end
    create_table :feeds_supercategories, id: false do |t|
      t.integer :feed_id
      t.integer :supercategory_id
    end
    drop_table :categories_feeds
  end
end
