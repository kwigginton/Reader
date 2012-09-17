class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :feed_url
      t.string :title
      t.string :author
      t.binary :feed_data

      t.timestamps
    end
  end
end
