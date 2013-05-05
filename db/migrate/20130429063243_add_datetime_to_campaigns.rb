class AddDatetimeToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :starttime, :datetime
    add_column :campaigns, :endtime, :datetime
  end
end
