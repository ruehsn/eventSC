class ParentMailer < ApplicationMailer
  def event_signup_confirmation(student)
    @events = student.event_options
                  .includes(:event)
                  .where.not(description: ["No, thanks", "Off campus"])
    @student = student
    mail(
      to: @student.parent_email,
      subject: "Event Signup Confirmation for #{@student.short_name}"
    )
  end
end
