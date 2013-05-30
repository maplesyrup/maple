class Renamepostscompanies < ActiveRecord::Migration
  def up
    rename_table :companies_posts, :banned_companies_posts
  end

  def down
    rename_table :banned_companies_posts, :companies_posts
  end
end
