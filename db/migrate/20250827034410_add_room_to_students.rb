class AddRoomToStudents < ActiveRecord::Migration[8.0]
  def change
    add_reference :students, :room, null: true, foreign_key: true
  end
end
