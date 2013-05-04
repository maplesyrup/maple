class AddTimeToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :starttime, :time
    add_column :campaigns, :endtime, :time
  end
end
