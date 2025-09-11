#!/usr/bin/env ruby
# Usage:
#   bin/rails runner script/add_users.rb
# Then paste / type email addresses (one per line). End input with Ctrl+D (Unix) or Ctrl+Z then Enter (Windows).
# Or pass a file: cat users.txt | bin/rails runner script/add_users.rb

abort "Run via 'bin/rails runner script/add_users.rb' inside the Rails app root" unless defined?(Rails)

puts "Enter email addresses (one per line). Blank line or EOF to finish:"

count_created = 0
count_existing = 0
errors = []

emails = []
ARGF.each_line do |line|
  line = line.strip.downcase
  break if line.empty?
  next if line.start_with?('#')
  emails << line
end

if emails.empty?
  puts "No emails provided. Exiting."
  exit 0
end

emails.uniq.each do |email|
  unless email.match?(/@shepherdscollege\.edu\z/)
    puts "Skipping invalid domain: #{email}"
    next
  end
  user = User.find_or_initialize_by(email: email)
  newly_created = user.new_record?
  # Note: is_admin defaults to false for regular users, so we don't need to set it
  begin
    if user.save
      if newly_created
        count_created += 1
        puts "Created user: #{email}"
      else
        count_existing += 1
        puts "User already exists: #{email}"
      end
    else
      errors << [ email, user.errors.full_messages.join(', ') ]
      puts "Failed: #{email} => #{user.errors.full_messages.join(', ')}"
    end
  rescue => e
    errors << [ email, e.message ]
    puts "Error processing #{email}: #{e.class} #{e.message}"
  end
end

puts "\nSummary:"
puts "  Created users: #{count_created}"
puts "  Already existing: #{count_existing}"
puts "  Total processed: #{emails.uniq.size}"
if errors.any?
  puts "  Errors: #{errors.size}"
  errors.each { |email, msg| puts "    #{email}: #{msg}" }
end
