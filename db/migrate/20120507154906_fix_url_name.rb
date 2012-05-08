class FixUrlName < ActiveRecord::Migration
  def change
    rename_column :feeds, :url, :feed_url
  end
  
end
