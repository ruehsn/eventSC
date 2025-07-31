class StagingMailInterceptor
  def self.delivering_email(message)
    message.subject = "[STAGING] #{message.subject} - [#{message.to}]"
    message.to = Rails.application.credentials.staging.mail_interceptor_to
  end
end

# if Rails.env.staging?
  ActionMailer::Base.register_interceptor(StagingMailInterceptor)
# end

class StagingMailObserver
  def self.delivered_email(message)
    Rails.logger.debug "EMAIL SENT __#{message.to}__#{message.subject}"
  end
end

ActionMailer::Base.register_observer(StagingMailObserver)