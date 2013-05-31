class UpdateEndorsed < ActiveRecord::Migration
  def up
    remove_column :posts, :endorsed
    add_column :posts, :endorsed, :boolean, :default => false
  end

  def down
    remove_column :posts, :endorsed
    add_column :posts, :endorsed, :boolean
  end
end
