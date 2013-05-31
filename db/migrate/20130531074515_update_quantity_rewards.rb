class UpdateQuantityRewards < ActiveRecord::Migration
  def up
    remove_column :rewards, :quantity
    add_column :rewards, :quantity, :integer, :default => 1
  end

  def down
    remove_column :rewards, :quantity
    add_column :rewards, :quantity
  end
end
