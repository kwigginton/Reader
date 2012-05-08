class AddIdsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :user_id, :integer

    add_column :subscriptions, :feed_id, :integer

  end
end
