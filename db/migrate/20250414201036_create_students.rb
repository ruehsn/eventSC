class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.string :short_name
      t.string :first_name
      t.string :last_name
      t.string :notes_url
      t.belongs_to :living_area, null: false, foreign_key: true
      t.belongs_to :advisor, null: false, foreign_key: true
      t.integer :year
      t.string :gender
      t.string :major
      t.boolean :student_life_holds_cash, default: false

      t.timestamps
    end

    add_index :students, :short_name, unique: true
  end
end
