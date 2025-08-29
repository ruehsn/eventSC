# Room seeding script based on building and room data
# When building and room number are the same, increment the room capacity

# Clear existing data in the right order to avoid foreign key constraints

# Room data from the provided list - [building, room_number, capacity]
room_data = [
  ['Cark', '1', 2],
  ['Cark', '2', 2],
  ['Cark', '3', 2],
  ['Cark', '4', 2],
  ['Cark', '5', 2],
  ['Cark', '6', 2],
  ['Cark', '7', 2],
  ['Cark', '8', 2],
  ['Cark', '9', 2],
  ['Cark', '10', 2],
  ['Cark', '11', 2],
  ['Cark', '12', 2],
  ['Cayton', '1', 1],
  ['Cayton', '2', 1],
  ['Cayton', '3', 1],
  ['Cook', 'W1', 2],
  ['Cook', 'W2', 2],
  ['Cook', 'W3', 2],
  ['Cook', 'W4', 2],
  ['Cook', 'E1', 2],
  ['Cook', 'E2', 2],
  ['Cook', 'E3', 2],
  ['Cook', 'E4', 2],
  ['Female Dorm', '117', 3],
  ['Female Dorm', '118', 3],
  ['Female Dorm', '120', 3],
  ['Female Dorm', '122', 3],
  ['Female Dorm', '124', 3],
  ['Female Dorm', '125', 3],
  ['Female Dorm', '126', 3],
  ['Female Dorm', '128', 3],
  ['Glanville', 'G1', 2],
  ['Glanville', 'G2', 2],
  ['Glanville', 'G3', 2],
  ['Glanville', 'G4', 2],
  ['Lamb', 'W2', 2],
  ['Lamb', 'W3', 2],
  ['Lamb', 'W4', 2],
  ['Lamb', 'W5', 2],
  ['Lamb', 'E1', 2],
  ['Lamb', 'E2', 2],
  ['Lamb', 'E3', 2],
  ['Lamb', 'E4', 2],
  ['Male Dorm', '13', 2],
  ['Male Dorm', '14', 3],
  ['Male Dorm', '15', 3],
  ['Male Dorm', '16', 2],
  ['Male Dorm', '17', 3],
  ['Male Dorm', '23 A', 1],
  ['Male Dorm', '23 B', 1],
  ['Male Dorm', '23 C', 1],
  ['Male Dorm', '6', 2],
  ['Male Dorm', '7', 3],
  ['Male Dorm', '8', 3],
  ['Male Dorm', '9', 3],
  ['Male Dorm', '10', 2],
  ['Olsen', 'O1', 2],
  ['Olsen', 'O2', 2],
  ['Olsen', 'O3', 2],
  ['Olsen', 'O4', 2]
]

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
