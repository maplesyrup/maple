class RemoveDatetimeFromCampaigns < ActiveRecord::Migration
  def up
    remove_column :campaigns, :starttime
    remove_column :campaigns, :endtime
  end

  def down
    add_column :campaigns, :starttime, :datetime, :null => false
    add_column :campaigns, :endtime, :datetime, :null => false
  end
end
