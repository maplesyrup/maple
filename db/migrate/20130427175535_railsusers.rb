class Railsusers < ActiveRecord::Migration
  def up
    create_table :rewards_users, :id => false do |t|
      t.references :user, :null => false
      t.references :reward, :null => false
    end
  end

  def down
    drop_table :rewards_users
  end
end
