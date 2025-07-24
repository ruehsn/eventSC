json.extract! vehicle, :id, :name, :passenger_capacity, :working, :note, :created_at, :updated_at
json.url vehicle_url(vehicle, format: :json)
