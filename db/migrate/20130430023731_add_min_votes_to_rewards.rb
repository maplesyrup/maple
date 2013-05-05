class AddMinVotesToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :min_votes, :integer, :default => nil
  end
end
