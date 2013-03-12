class UpdatePasswordColumnInCompanies < ActiveRecord::Migration
  def change
  	rename_column :companies, :password, :encrypted_password
  end
end
