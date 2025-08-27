class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.string :room_number
      t.integer :capacity
      t.references :living_area, null: false, foreign_key: true
      t.integer :x_position
      t.integer :y_position
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
