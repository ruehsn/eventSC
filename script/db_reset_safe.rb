#!/usr/bin/env ruby
# Usage: bin/rails runner script/db_reset_safe.rb
# This script safely resets the database with proper ownership

abort "This script should only be run in production environments" unless Rails.env.production? || Rails.env.staging?

puts "Starting safe database reset..."

# Run database reset
system("rails db:reset")

# Fix ownership if running as root
if Process.uid == 0
  puts "Fixing database file ownership..."
  system("chown -R rails:rails /data/")
  puts "Ownership fixed!"
end

puts "Database reset completed safely!"
