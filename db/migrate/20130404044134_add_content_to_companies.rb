class AddContentToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :blurb_title, :string, :null => false, :default => "Company Blurb" 	 
  	add_column :companies, :blurb_body, :string, :null => false, :default => "Hey, this is our company!" 
  	add_column :companies, :more_info_title, :string, :null => false, :default => "More Info"
  	add_column :companies, :more_info_body, :string, :null => false, :default => "Here's a little more about us."
  	
  end
end
