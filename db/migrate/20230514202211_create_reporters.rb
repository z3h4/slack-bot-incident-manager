class CreateReporters < ActiveRecord::Migration[7.0]
  def change
    create_table :reporters do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
