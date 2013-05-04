class AddRewardToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :reward, :string
  end
end
