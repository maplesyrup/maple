class AddAdCreationLogToLogEntries < ActiveRecord::Migration
  def change
    add_column :log_entries, :ad_creation_log, :string
  end
end
