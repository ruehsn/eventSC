class DelayedParentEmailJob < ApplicationJob
  queue_as :default

  def perform(student_id, job_key)
    student = Student.find_by(id: student_id)
    return unless student&.parent_email.present?

    # Check if this is still the most recent job for this student
    current_job_key = Rails.cache.read("parent_email_job_#{student_id}")
    return unless current_job_key == job_key

    # Send the email
    ParentMailer.event_signup_confirmation(student).deliver_now

    # Clean up the cache entry
    Rails.cache.delete("parent_email_job_#{student_id}")

    Rails.logger.info "Sent delayed parent email for student #{student.short_name} (#{student_id})"
  rescue => e
    Rails.logger.error "Failed to send delayed parent email for student #{student_id}: #{e.message}"
  end
end
