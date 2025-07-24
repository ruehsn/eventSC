class CreateLivingAreas < ActiveRecord::Migration[8.0]
  def change
    create_table :living_areas do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
