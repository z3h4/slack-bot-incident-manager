class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :team_id, :string, null: false
    add_column :users, :access_token, :string
  end
end
