class Removequalifyingclassfromrewards < ActiveRecord::Migration
  def up
    remove_column :rewards, :qualifying_class
  end

  def down
    add_column :rewards, :qualifying_class, :integer, :default => 0
  end
end
