class ParentMailer < ApplicationMailer
  def event_signup_confirmation(student)
    @student = student
    mail(
      to: @student.parent_email,
      subject: "Event Signup Confirmation for #{@student.short_name}"
    )
  end
end
