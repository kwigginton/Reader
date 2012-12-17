class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes, :id => false do |t|
      t.integer :user_id
      t.references :votable, polymorphic: true
      t.timestamps
    end
  end
end
