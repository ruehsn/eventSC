class AddPhotoToStudents < ActiveRecord::Migration[8.0]
  def change
    # Active Storage will handle photo attachments through the Student model
    # No table changes needed
  end
end
