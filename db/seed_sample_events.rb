
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
[ "Culvers", "Pizza Ranch", "Chick-fil-A", "Wendy's", "Taco Bell" ].each do |restaurant|
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
[ "Panda Express", "Chipotle", "Chick-fil-A", "Five Guys", "MOD Pizza" ].each do |restaurant|
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
[ today+14, today+15 ].each do |date|
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
