class AddRequirementClassToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :requirement_type, :string, :default => "NONE"
  end
end
