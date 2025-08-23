class StagingMailInterceptor
  def self.delivering_email(message)
    if ! Rails.env.production?
      message.subject = "[Event-Preview] #{message.subject} __| TO: #{message.to}"
    end
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