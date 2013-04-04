class RemoveContentFromCompanies < ActiveRecord::Migration
  def up
  	remove_column :companies, :company_blurb
  	remove_column :companies, :more_info
  end

  def down
  	add_column :companies, :company_blurb, :string, :null => false, :default => "Your company blurb" 	 
  	add_column :companies, :more_info, :string, :null => false, :default => "More space for information here"
  end
end
