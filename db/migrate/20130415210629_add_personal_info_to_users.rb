class AddPersonalInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :personal_info, :text
  end
end
