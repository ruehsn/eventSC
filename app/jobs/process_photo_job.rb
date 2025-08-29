class ProcessPhotoJob < ApplicationJob
  queue_as :default

  def perform(student)
    return unless student.photo.attached?
    
    begin
      # Log that photo processing was triggered
      Rails.logger.info "Photo processing job triggered for student #{student.id} (#{student.display_name})"
      
      # For now, just keep the original photo as-is
      # Photo cropping functionality has been disabled
      
    rescue => e
      Rails.logger.error "Photo processing job failed for student #{student.id}: #{e.message}"
    end
  end
end
