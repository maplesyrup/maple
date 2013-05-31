class AddEndorsedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :endorsed, :boolean
  end
end
