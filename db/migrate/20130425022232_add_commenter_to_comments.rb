class AddCommenterToComments < ActiveRecord::Migration
  def change
    add_column :comments, :commenter_id, :integer
    add_column :comments, :commenter_type, :string
  end
end
