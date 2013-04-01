class AddContentToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :splash_image, :string, :null => false, :default => "http://www.hybridlava.com/wp-content/uploads/Wide_wallPAPER011.jpg"
 	add_column :companies, :company_blurb, :string, :null => false, :default => "Your company blurb" 	 
  	add_column :companies, :more_info, :string, :null => false, :default => "More space for information here"
  end
end
