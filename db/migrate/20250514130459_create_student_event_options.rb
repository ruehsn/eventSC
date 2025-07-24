class CreateStudentEventOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :student_event_options do |t|
      t.references :student, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.references :event_option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
