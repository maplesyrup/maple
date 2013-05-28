class AddTopPostsToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :number_of_leaders, :integer, :default => 0
    add_column :rewards, :min_votes_to_lead, :integer, :default => 0
    add_column :rewards, :users_can_win, :integer, :default => 1
  end
end
