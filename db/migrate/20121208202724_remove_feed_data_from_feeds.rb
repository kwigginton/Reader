class RemoveFeedDataFromFeeds < ActiveRecord::Migration
  def change
    remove_column :feeds, :feed_data
  end
end
