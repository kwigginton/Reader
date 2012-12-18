class CreateJoinPostsSupercategories < ActiveRecord::Migration
  def change
    create_table :posts_supercategories, id: false do |t|
      t.integer :post_id
      t.integer :supercategory_id
    end
  end
end
