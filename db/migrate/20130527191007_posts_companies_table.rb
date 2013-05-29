class PostsCompaniesTable < ActiveRecord::Migration
  def change
    create_table :companies_posts do |t|
      t.references :company, :null => false
      t.references :post, :null => false
    end
  end
end
