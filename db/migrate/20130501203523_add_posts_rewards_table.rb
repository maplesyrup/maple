class AddPostsRewardsTable < ActiveRecord::Migration
  def up
    create_table :posts_rewards, :id => false do |t|
      t.references :post, :null => false
      t.references :reward, :null => false
    end
  end

  def down
    drop_table :posts_rewards
  end
end
