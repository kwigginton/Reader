class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :feed_id
      t.binary :summary
      t.binary :content
      t.string :author
      t.float :rank

      t.timestamps
    end
  end
end
