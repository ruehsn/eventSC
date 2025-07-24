class CreateEventOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :event_options do |t|
      t.text :description
      t.decimal :cost
      t.boolean :office_holds_cash
      t.boolean :transportation_required
      t.integer :event_id
      
      t.timestamps
    end
  end
end
