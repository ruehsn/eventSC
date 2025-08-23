class ParentMailer < ApplicationMailer
  def event_signup_confirmation(student, to_override=nil)
    @recipient = to_override.nil? ? @student.parent_email : to_override

    @events = student.event_options
                  .includes(:event)
                  .where.not(description: ["No, thanks", "Off campus"])
    @student = student
    mail(
      to: @recipient,
      subject: "Event Signup Confirmation for #{@student.short_name}"
    )
  end
end
