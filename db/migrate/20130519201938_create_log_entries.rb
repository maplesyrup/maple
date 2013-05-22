class CreateLogEntries < ActiveRecord::Migration
  def change
    create_table :log_entries do |t|
      t.string :additt_version
      t.string :android_build
      t.string :time
      t.string :stack_trace

      t.timestamps
    end
  end
end
