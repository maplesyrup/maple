class AddReferenceToAttachable < ActiveRecord::Migration
  def self.up
    change_table :assets do |t|
      t.references :attachable, :polymorphic => true
    end
  end

  def self.down
    change_table :assets do |t|
      t.remove_references :attachable, :polymorphic => true
    end
  end
end
