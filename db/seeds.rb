require 'csv'
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding database..."

# Create development users in development environment first
if Rails.env.development? 
  puts "Creating development users..."
  User.find_or_create_by(email: 'user@shepherdscollege.edu')
  admin_user = User.find_or_create_by(email: 'admin@shepherdscollege.edu')
  
  # Make the admin user an admin
  admin_user.update!(is_admin: true)
  puts "Development users created! Admin: #{admin_user.email}"
end

# Clear existing data (but preserve users) - order matters due to foreign keys
StudentEventOption.delete_all  # Delete join table records first
EventOption.delete_all
Event.delete_all
Student.delete_all  # Delete students first since they reference advisors and living areas
Advisor.delete_all
LivingArea.delete_all

"Anderson|Bakovka|Calabrese|Tarwater|McCoy|Sliwinski|Kapity".split("|").each do |name|
    Advisor.find_or_create_by(last_name: name)
end

"Male Dorm|Female Dorm|Cook East|Cook West|Glanville|Lamb East|Lamb West|Male Clark|Female Clark / Olsen".split("|").each do |name|
    LivingArea.find_or_create_by!(name: name)
end

CSV.foreach("db/students.tdf", col_sep: "\t", :headers => true, :header_converters => :symbol) do |row|
    begin
        Student.find_or_create_by!(first_name: row[:first], 
                                last_name:  row[:last], 
                                short_name: row[:short_name], 
                                year:       row[:year], 
                                notes_url:  row[:url], 
                                gender:     row[:gender], 
                                major:      row[:major],
                                parent_email: "parent@example.com",
                                advisor_id: Advisor.find_by(  last_name: row[:advisor]).id,
                            living_area_id: LivingArea.find_by(    name: row[:living_area]).id)
    rescue ActiveRecord::RecordInvalid => e
        puts "Error creating student: #{e.message}: #{row[:short_name]} #{row[:living_area]} #{row[:advisor]}"
    end
end

today = Date.today + ((5 - Date.today.wday) % 7)

# Helper method to create time objects
def time_obj(hour, min)
  Time.parse("#{hour}:#{min}")
end

# Morning events (typically 9am-12pm)
e = Event.find_or_create_by!(name: "Morning", date: today - 14)
EventOption.find_or_create_by!(
  event_id: e.id, 
  description: "Mitchell Domes & Train Exhibit", 
  cost: 6, 
  office_holds_cash: true, 
  transportation_required: true, 
  leave_time: time_obj(9, 0), 
  return_time: time_obj(12, 0)
)
EventOption.find_or_create_by!(event_id: e.id, description: "No, thanks", cost: 0, office_holds_cash: true, transportation_required: false, leave_time: nil, return_time: nil)
EventOption.find_or_create_by!(event_id: e.id, description: "Off Campus", cost: 0, office_holds_cash: true, transportation_required: false, leave_time: nil, return_time: nil)

# Afternoon events (typically 13:00-16:00)
e = Event.find_or_create_by!(name: "Afternoon", date: today - 7)
EventOption.find_or_create_by!(
  event_id: e.id, 
  description: "Zoo Trip", 
  cost: 14, 
  office_holds_cash: true, 
  transportation_required: true, 
  leave_time: time_obj(13, 0), 
  return_time: time_obj(16, 0)
)
EventOption.find_or_create_by!(event_id: e.id, description: "No, thanks", cost: 0, office_holds_cash: true, transportation_required: false, leave_time: nil, return_time: nil)
EventOption.find_or_create_by!(event_id: e.id, description: "Off Campus", cost: 0, office_holds_cash: true, transportation_required: false, leave_time: nil, return_time: nil)

# Haircut events (typically scheduled during the day)
e = Event.find_or_create_by!(name: "Haircut", date: today -6)
EventOption.find_or_create_by!(event_id: e.id, description: "Yes", cost: 12, office_holds_cash: true, transportation_required: false, leave_time: "14:00", return_time: "15:00")
EventOption.find_or_create_by!(event_id: e.id, description: "No, thanks", cost: 0, office_holds_cash: true, transportation_required: false, leave_time: nil, return_time: nil)

# Dinner events (already has times, keep as is)
e = Event.find_or_create_by!(name: "Dinner Out", date: today)
["Culvers", "Pizza Ranch", "Chick-fil-A", "Wendy's", "Taco Bell"].each do |restaurant|
  EventOption.find_or_create_by!(
    event_id: e.id, 
    description: restaurant, 
    cost: 15, 
    office_holds_cash: false, 
    transportation_required: true, 
    leave_time: time_obj(17, 0), 
    return_time: time_obj(19, 0)
  )
end

# For "No, thanks" and "Off Campus" options, use nil times
EventOption.find_or_create_by!(
  event_id: e.id, 
  description: "No, thanks", 
  cost: 0, 
  office_holds_cash: false, 
  transportation_required: true,
  leave_time: nil,
  return_time: nil
)

EventOption.find_or_create_by!(
  event_id: e.id, 
  description: "Off Campus", 
  cost: 0, 
  office_holds_cash: true, 
  transportation_required: false,
  leave_time: nil,
  return_time: nil
)


# Update the second Dinner Out event
e = Event.find_or_create_by!(name: "Dinner Out", date: today+7)
["Panda Express", "Chipotle", "Chick-fil-A", "Five Guys", "MOD Pizza"].each do |restaurant|
  EventOption.find_or_create_by!(
    event_id: e.id, 
    description: restaurant, 
    cost: 15, 
    office_holds_cash: false, 
    transportation_required: true, 
    leave_time: time_obj(17, 0), 
    return_time: time_obj(19, 0)
  )
end
EventOption.find_or_create_by!(event_id: e.id, description: "No, thanks", cost: 0, office_holds_cash: false, transportation_required: true, leave_time: nil, return_time: nil)
EventOption.find_or_create_by!(event_id: e.id, description: "Off Campus", cost: 0, office_holds_cash: true, transportation_required: false, leave_time: nil, return_time: nil)

# Morning events with proper time objects
e = Event.find_or_create_by!(name: "Morning", date: today +8)
EventOption.find_or_create_by!(
  event_id: e.id, 
  description: "Discovery World Museum & Aquarium", 
  cost: 15, 
  office_holds_cash: false, 
  transportation_required: true, 
  leave_time: time_obj(9, 0), 
  return_time: time_obj(12, 0)
)
EventOption.find_or_create_by!(
  event_id: e.id, 
  description: "Trip to Library", 
  cost: 0, 
  office_holds_cash: false, 
  transportation_required: true, 
  leave_time: time_obj(10, 0), 
  return_time: time_obj(11, 30)
)
EventOption.find_or_create_by!(event_id: e.id, description: "No, thanks", cost: 0, office_holds_cash: false, transportation_required: false, leave_time: nil, return_time: nil)
EventOption.find_or_create_by!(event_id: e.id, description: "Off Campus", cost: 0, office_holds_cash: false, transportation_required: false, leave_time: nil, return_time: nil)

# Haircut events with proper time objects
[today+14, today+15].each do |date|
  e = Event.find_or_create_by!(name: "Haircut", date: date)
  EventOption.find_or_create_by!(
    event_id: e.id, 
    description: "Yes", 
    cost: 12, 
    office_holds_cash: true, 
    transportation_required: false,
    leave_time: time_obj(14, 0),
    return_time: time_obj(15, 0)
  )
  EventOption.find_or_create_by!(event_id: e.id, description: "No, thanks", cost: 0, office_holds_cash: true, transportation_required: false, leave_time: nil, return_time: nil)
end

# Morning events with proper time objects
e = Event.find_or_create_by!(name: "Morning", date: today+21)
EventOption.find_or_create_by!(
  event_id: e.id, 
  description: "Library", 
  cost: 0, 
  office_holds_cash: true, 
  transportation_required: true,
  leave_time: time_obj(10, 0),
  return_time: time_obj(11, 30)
)
EventOption.find_or_create_by!(
  event_id: e.id, 
  description: "Craft", 
  cost: 1, 
  office_holds_cash: true, 
  transportation_required: false,
  leave_time: time_obj(9, 0),
  return_time: time_obj(10, 30)
)
EventOption.find_or_create_by!(event_id: e.id, description: "No, thanks", cost: 0, office_holds_cash: true, transportation_required: false, leave_time: nil, return_time: nil)


# Assign Random EventOptions to Students
Student.all.each do |student|
  Event.all.each do |event|
    event_options = event.event_options
    off_campus_option = event_options.find { |eo| eo.description =~ /Off Campus/i }
    other_options = event_options.reject { |eo| eo.description =~ /Off Campus/i }

    # Assign Off Campus to 10% of students, others get a random non-Off Campus option
    if off_campus_option && rand < 0.1
      StudentEventOption.find_or_create_by!(student_id: student.id, event_id: event.id, event_option_id: off_campus_option.id)
    else
      random_option = other_options.sample
      # Only assign if there is a non-Off Campus option
      if random_option
        StudentEventOption.find_or_create_by!(student_id: student.id, event_id: event.id, event_option_id: random_option.id)
      end
    end
  end
end
  
# Randomly assign `student_life_holds_cash` to true for 20% of students
students = Student.all.to_a
students.sample((students.size * 0.2).ceil).each do |student|
  student.update!(student_life_holds_cash: true)
  puts "Updated student #{student.short_name} to student life holds cash."
end

#radomally delete 15 student life event selections to simulate students not signing up for events
StudentEventOption.all.sample(15).each{|seo| seo.destroy}


puts "Database seeding completed!"