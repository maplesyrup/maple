class AddQuantityToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :quantity, :integer
  end
end
