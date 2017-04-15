json.(@company, :id, :name, :splash_image, :company_blurb, :more_info, :company_url)
json.editable true if @company_editable else false