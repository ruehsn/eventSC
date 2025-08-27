class DelayedParentEmailService
  DELAY_HOURS = 2

  def self.schedule_email(student)
    return unless student.parent_email.present?

    # Generate a unique job key for this email
    job_key = SecureRandom.uuid
    cache_key = "parent_email_job_#{student.id}"

    # Cancel any existing scheduled email for this student
    existing_job_key = Rails.cache.read(cache_key)
    if existing_job_key.present?
      # Try to cancel the existing job (this works with some job adapters)
      cancel_existing_job(student.id, existing_job_key)
      Rails.logger.info "Cancelled existing parent email job for student #{student.short_name}"
    end

    # Store the new job key in cache
    Rails.cache.write(cache_key, job_key, expires_in: (DELAY_HOURS + 1).hours)

    # Schedule the new job
    DelayedParentEmailJob.set(wait: DELAY_HOURS.hours).perform_later(student.id, job_key)

    Rails.logger.info "Scheduled delayed parent email for student #{student.short_name} in #{DELAY_HOURS} hours"

    job_key
  end

  def self.cancel_email(student)
    cache_key = "parent_email_job_#{student.id}"
    existing_job_key = Rails.cache.read(cache_key)

    if existing_job_key.present?
      cancel_existing_job(student.id, existing_job_key)
      Rails.cache.delete(cache_key)
      Rails.logger.info "Cancelled scheduled parent email for student #{student.short_name}"
      return true
    end

    false
  end

  def self.send_immediately(student)
    # Cancel any delayed email
    cancel_email(student)

    # Send immediately
    if student.parent_email.present?
      ParentMailer.event_signup_confirmation(student).deliver_now
      Rails.logger.info "Sent immediate parent email for student #{student.short_name}"
    end
  end

  def self.pending_emails_count
    # Count cache entries that match our pattern
    cache_keys = Rails.cache.instance_variable_get(:@data)&.keys || []
    cache_keys.count { |key| key.to_s.start_with?("parent_email_job_") }
  end

  def self.pending_emails_for_student(student)
    cache_key = "parent_email_job_#{student.id}"
    job_key = Rails.cache.read(cache_key)
    job_key.present?
  end

  private

  def self.cancel_existing_job(student_id, job_key)
    # This is adapter-specific. For development, we rely on the job_key check in the job itself.
    # For production with Redis/Sidekiq, you could implement more sophisticated cancellation.
    Rails.logger.info "Marking job #{job_key} for student #{student_id} as cancelled"
  end
end
