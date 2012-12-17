class AddGuidAndPublishedAtToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :guid, :string
    add_column :posts, :published_at, :datetime
  end
end
