class AddDefaultRoleToUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :role, :string, :default => "reader"
  end

  def self.down
    # You can't currently remove default values in Rails
    raise ActiveRecord::IrreversibleMigration, "Can't remove the default"
  end
end
