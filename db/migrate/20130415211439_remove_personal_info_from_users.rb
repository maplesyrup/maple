class RemovePersonalInfoFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :personal_info
  end

  def down
    add_column :users, :personal_info, :text
  end
end
