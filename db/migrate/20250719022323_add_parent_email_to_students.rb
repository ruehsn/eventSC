class AddParentEmailToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :parent_email, :string
  end
end
