# Sample room data for demonstration
# This creates a simple hallway layout for each living area

living_areas = LivingArea.all

if living_areas.any?
  living_areas.each_with_index do |living_area, area_index|
    # Clear existing rooms for clean demo
    living_area.rooms.destroy_all
    
    puts "Creating rooms for #{living_area.name}..."
    
    # Create a hallway layout with rooms on both sides
    # Left side rooms
    (1..5).each do |room_num|
      Room.create!(
        room_number: "#{area_index + 1}0#{room_num}",
        capacity: [1, 2, 2, 1, 2].sample, # Varied capacity
        living_area: living_area,
        x_position: 50,
        y_position: 50 + (room_num - 1) * 100,
        width: 120,
        height: 80
      )
    end
    
    # Right side rooms
    (6..10).each do |room_num|
      Room.create!(
        room_number: "#{area_index + 1}#{room_num - 5}#{room_num - 5}",
        capacity: [1, 2, 2, 1, 2].sample,
        living_area: living_area,
        x_position: 300,
        y_position: 50 + (room_num - 6) * 100,
        width: 120,
        height: 80
      )
    end
    
    # Common area
    Room.create!(
      room_number: "Common",
      capacity: 8,
      living_area: living_area,
      x_position: 480,
      y_position: 150,
      width: 150,
      height: 200
    )
    
    puts "Created #{living_area.rooms.count} rooms for #{living_area.name}"
  end
else
  puts "No living areas found. Please create some living areas first."
  puts "Example:"
  puts "LivingArea.create!(name: 'North Hall', description: 'Main dormitory building')"
  puts "LivingArea.create!(name: 'South Hall', description: 'Secondary dormitory building')"
end

puts "Room seeding complete!"
