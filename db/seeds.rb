require 'csv'
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding database..."

# Clear existing data (but preserve users) - order matters due to foreign keys
StudentEventOption.delete_all  # Delete join table records first
EventOption.delete_all
Event.delete_all
Student.delete_all  # Delete students first since they reference advisors and living areas
Room.delete_all     # Delete rooms before living areas
Advisor.delete_all
LivingArea.delete_all

# Load room data from separate seed files
puts "Loading room data..."
load Rails.root.join('db', 'seeds_rooms_data.rb')
puts "Room data loaded!"

# Create development users in development environment first
if Rails.env.development?
  puts "Creating development users..."
  User.find_or_create_by(email: 'user@shepherdscollege.edu')
  admin_user = User.find_or_create_by(email: 'admin@shepherdscollege.edu')

  # Make the admin user an admin
  admin_user.update!(is_admin: true)
  puts "Development users created! Admin: #{admin_user.email}"
end


CSV.foreach("db/students.tdf", col_sep: "\t", headers: true, header_converters: :symbol) do |row|
  # Convert CSV::Row to hash and normalize '0' strings to empty string
  normalized = row.to_h.transform_values { |v| v == '0' ? '' : v }

  begin
    # Find the living area
    living_area = LivingArea.find_or_create_by(name: normalized[:living_area])
    
    # Find the room within that living area if room is specified
    room = nil
    if normalized[:room].present?
      room = Room.find_by(living_area: living_area, room_number: normalized[:room])
      if room.nil?
        puts "Warning: Room #{normalized[:room]} not found in #{normalized[:living_area]} for student #{normalized[:short_name]}"
      end
    end

    Student.find_or_create_by!(
      first_name:     normalized[:first],
      last_name:      normalized[:last],
      short_name:     normalized[:short_name],
      year:           normalized[:year],
      notes_url:      normalized[:url],
      gender:         normalized[:gender].upcase,
      major:          normalized[:major],
      # parent_email:   normalized[:parent_email],
      advisor_id:     Advisor.find_or_create_by(last_name: normalized[:advisor]).id,
      living_area_id: living_area.id,
      room_id:        room&.id
    )
  rescue ActiveRecord::RecordInvalid => e
    puts "Error creating student: #{e.message}: #{normalized[:short_name]} #{normalized[:living_area]} #{normalized[:advisor]}"
  end
end

def seed_sample_events()
  puts "seeding sample events"
  load Rails.root.join('db', 'seed_sample_events.rb')

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
end

if !Rails.env.production?
  seed_sample_events()
  
  puts "Assigning student life holds cash to 20% of students..."
  students = Student.all.to_a
  students.sample((students.size * 0.2).ceil).each do |student|
    student.update!(student_life_holds_cash: true)
    puts "Updated student #{student.short_name} to student life holds cash."
  end

  puts "Randomly delete 15 student life event selections to simulate students not signing up for events"
  StudentEventOption.all.sample(15).each { |seo| seo.destroy }
end

puts "Database seeding completed!"

load Rails.root.join('script', 'add_admin_users.rb') unless Rails.env.development?


