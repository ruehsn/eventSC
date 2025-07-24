class AddExternalIdToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :external_id, :string
  end
end
