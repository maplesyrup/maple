class AddRemeberablesToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :remember_created_at, :datetime
  end
end
