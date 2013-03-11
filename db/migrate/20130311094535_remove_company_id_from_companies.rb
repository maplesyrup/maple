class RemoveCompanyIdFromCompanies < ActiveRecord::Migration
  def up
  	remove_column :companies, :company_id
  end

  def down
  	add_column :companies, :company_id
  end
end
