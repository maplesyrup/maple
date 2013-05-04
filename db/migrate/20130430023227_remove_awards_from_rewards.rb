class RemoveAwardsFromRewards < ActiveRecord::Migration
  def up
    remove_column :rewards, :monetary_reward
    remove_column :rewards, :swag_award
  end

  def down
    add_column :rewards, :monetary_reward, :integer
    add_column :rewards, :swag_award, :string
  end
end
