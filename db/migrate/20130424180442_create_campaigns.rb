class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :title
      t.text  :description
      t.datetime :starttime
      t.datetime :endtime

      t.integer :company_id
       
      t.timestamps
    end
  end
end
