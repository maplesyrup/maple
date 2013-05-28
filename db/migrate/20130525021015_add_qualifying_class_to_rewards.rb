class AddQualifyingClassToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :qualifying_class, :integer, :default => 0 
  end
end
