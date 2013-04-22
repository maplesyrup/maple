class AddDefaultPersonalInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :personal_info, :text, :default => "A little about me."
  end
end
