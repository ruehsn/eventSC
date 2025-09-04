# Room seeding script based on building and room data
# When building and room number are the same, increment the room capacity

# Clear existing data in the right order to avoid foreign key constraints

# Room data from the provided list - [building, room_number, capacity]
# Load room data from rooms.tdf file
require 'csv'

room_data = []
CSV.foreach(Rails.root.join('db', 'rooms.tdf'), col_sep: "\t") do |row|
  building, room_number, capacity = row
  room_data << [building, room_number, capacity.to_i]
end

puts "Loaded #{room_data.count} rooms from rooms.tdf"

# Get unique living areas (buildings) and find or create them


unique_buildings = room_data.map(&:first).uniq

puts "Finding or creating living areas..."
living_areas = {}
unique_buildings.each do |building_name|
  living_area = LivingArea.find_or_create_by!(
    name: building_name
  ) do |la|
    la.description = "#{building_name} dormitory building"
  end
  living_areas[building_name] = living_area
  puts "  Found/created living area: #{building_name}"
end

# Create rooms with explicit capacities
puts "\nCreating rooms..."
room_data.each_with_index do |(building, room_number, capacity), index|
  living_area = living_areas[building]
  
  # Calculate position based on room index within the building
  building_rooms = room_data.select { |b, r, c| b == building }
  room_index = building_rooms.map { |b, r, c| "#{b}|#{r}" }.index("#{building}|#{room_number}")
  
  # Layout rooms in a grid pattern
  cols = [4, Math.sqrt(building_rooms.count).ceil].max
  col = room_index % cols
  row = room_index / cols
  
  x_position = 50 + col * 180
  y_position = 50 + row * 140
  width = 160
  height = 120
  
  room = Room.create!(
    room_number: room_number,
    capacity: capacity,
    living_area: living_area,
    x_position: x_position,
    y_position: y_position,
    width: width,
    height: height
  )
  
  puts "  Created room #{building} #{room_number} (capacity: #{capacity}) at (#{x_position}, #{y_position})"
end

puts "\nRoom seeding completed!"
puts "Summary:"
living_areas.each do |name, living_area|
  room_count = living_area.rooms.count
  total_capacity = living_area.rooms.sum(:capacity)
  puts "  #{name}: #{room_count} rooms, #{total_capacity} total capacity"
end

total_rooms = Room.count
total_capacity = Room.sum(:capacity)
puts "\nOverall: #{total_rooms} rooms, #{total_capacity} total bed spaces"
