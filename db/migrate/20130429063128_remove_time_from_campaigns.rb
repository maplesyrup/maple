class RemoveTimeFromCampaigns < ActiveRecord::Migration
  def up
    remove_column :campaigns, :starttime
    remove_column :campaigns, :endtime
  end

  def down
    add_column :campaigns, :starttime, :time
    add_column :campaigns, :endtime, :time
  end
end
