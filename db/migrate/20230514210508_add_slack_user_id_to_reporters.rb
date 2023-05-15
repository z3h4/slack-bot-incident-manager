class AddSlackUserIdToReporters < ActiveRecord::Migration[7.0]
  def change
    add_column :reporters, :slack_user_id, :string
  end
end
