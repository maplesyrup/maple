class AddSplashImageToCompanies < ActiveRecord::Migration
  def change
  	add_attachment :companies, :splash_image
  end
end
