class AddTeamIdToIncidents < ActiveRecord::Migration[7.0]
  def change
    add_reference :incidents, :team, foreign_key: true
  end
end
