class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.integer :campaign_id
      t.string  :title
      t.text  :description
      t.integer :monetary_reward
      t.string  :swag_award
       
      t.timestamps
    end
  end
end
