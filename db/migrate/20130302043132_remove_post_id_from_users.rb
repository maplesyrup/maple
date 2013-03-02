class RemovePostIdFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :post_id
  end

  def down
    add_column :users, :post_id
  end
end
