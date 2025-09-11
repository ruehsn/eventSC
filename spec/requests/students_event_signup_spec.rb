require 'rails_helper'

RSpec.describe "Student event signup", type: :request do
  describe "POST /students/:id/submit_event_options" do
    it "redirects back to the referring page after saving selections" do
      # Create minimal records
      student = Student.create!(short_name: 's1', first_name: 'Test', last_name: 'Student')
      event = Event.create!(name: 'Fun Event', starts_at: 1.day.from_now, ends_at: 1.day.from_now + 2.hours)
      option = EventOption.create!(event: event, name: 'Option A', price_cents: 0)

      # Simulate coming from another page
      referer = '/students'

      post submit_event_options_student_path(student), params: { event_options: { event.id.to_s => option.id.to_s } }, headers: { "HTTP_REFERER" => referer }

      expect(response).to redirect_to(referer)
      follow_redirect!
      expect(response.body).to include("Event selections saved")
    end
  end
end
