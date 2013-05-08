class AddSelectedToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :selected, :boolean
  end
end
