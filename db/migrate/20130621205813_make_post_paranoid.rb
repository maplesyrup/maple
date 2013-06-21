class MakePostParanoid < ActiveRecord::Migration
  def up
    add_column :posts, :deleted_at, :datetime
  end

  def down
    remove_column :posts, :deleted_at
  end
end
