class AddTimesToEventOptions < ActiveRecord::Migration[8.0]
  def change
    add_column :event_options, :leave_time, :time
    add_column :event_options, :return_time, :time
  end
end