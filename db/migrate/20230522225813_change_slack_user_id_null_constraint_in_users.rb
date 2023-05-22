class ChangeSlackUserIdNullConstraintInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :slack_user_id, false
  end
end
