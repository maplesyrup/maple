class RemoveUnusedColumnsFromRewards < ActiveRecord::Migration
  def up
    remove_column :rewards, :users_can_win
    remove_column :rewards, :number_of_leaders
    rename_column :rewards, :requirement_type, :requirement
  end

  def down
    add_column :rewards, :users_can_win, :integer
    add_column :rewards, :number_of_leaders, :integer
    rename_column :rewards, :method, :requirement_type, :string
  end
end
