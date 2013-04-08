class RemoveSplashImageFromCompanies < ActiveRecord::Migration
  def up
  	remove_column :companies, :splash_image
  end

  def down
  	add_column :companies, :splash_image, :string, :null => false, :default => "http://www.hybridlava.com/wp-content/uploads/Wide_wallPAPER011.jpg"
  end
end
