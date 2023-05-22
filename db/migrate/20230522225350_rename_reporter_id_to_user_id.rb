class RenameReporterIdToUserId < ActiveRecord::Migration[7.0]
  def change
    rename_column :incidents, :reporter_id, :user_id
  end
end
