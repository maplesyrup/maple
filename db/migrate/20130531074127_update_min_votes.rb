class UpdateMinVotes < ActiveRecord::Migration
  def up
    remove_column :rewards, :min_votes
    add_column :rewards, :min_votes, :integer, :default => 1
  end

  def down
    remove_column :rewards, :min_votes
    add_column :rewards, :min_votes, :integer   
  end
end
