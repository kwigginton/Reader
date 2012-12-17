class AddTitleToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :title, :string
  end

  def down
    remove_column :posts, :title
  end
end
