class AddEmailToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :email, :string, :null => false, :default => ""
  end
end
