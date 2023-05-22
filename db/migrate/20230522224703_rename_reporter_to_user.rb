class RenameReporterToUser < ActiveRecord::Migration[7.0]
  def change
    rename_table :reporters, :users
  end
end
