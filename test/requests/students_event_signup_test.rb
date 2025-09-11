require "test_helper"

class StudentsEventSignupTest < ActionDispatch::IntegrationTest
  test "redirects back to referring page after saving selections" do
  living_area = LivingArea.create!(name: 'Test Hall')
  advisor = Advisor.create!(first_name: 'Adv', last_name: 'Isor')
  student = Student.create!(short_name: 's1', first_name: 'Test', last_name: 'Student', living_area: living_area, advisor: advisor)
  event = Event.create!(name: 'Fun Event', date: 1.day.from_now.to_date)
  option = EventOption.create!(event: event, description: 'Option A', cost: 0)

  referer = '/students'

  # Create a user and use the development login helper route to set session
  user = User.create!(email: 'tester@shepherdscollege.edu')
  post '/dev_login', params: { email: user.email }

  post submit_event_options_student_path(student), params: { event_options: { event.id.to_s => option.id.to_s } }, headers: { 'HTTP_REFERER' => referer }

  assert_redirected_to referer
  follow_redirect!
  assert_match "Event selections saved", @response.body
  end
end
