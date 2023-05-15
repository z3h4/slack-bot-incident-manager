class CreateIncidents < ActiveRecord::Migration[7.0]
  def change
    create_table :incidents do |t|
      t.string :title, null: false
      t.text :description
      t.string :severity
      t.string :channel_id, null: false
      t.references :reporter, null: false, foreign_key: true
      t.timestamp :resolved_at

      t.timestamps
    end
  end
end
