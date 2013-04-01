class AddImageToCompany < ActiveRecord::Migration
  def change
  	add_column :companies, :image, :string, :null => false, :default => ""
  end
end
