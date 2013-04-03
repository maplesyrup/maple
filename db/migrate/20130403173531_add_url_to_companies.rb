class AddUrlToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :company_url, :string, :null => false, :default => ""
  end
end
