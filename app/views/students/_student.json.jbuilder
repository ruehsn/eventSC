json.extract! student, :id, :short_name, :first_name, :last_name, :notes_url, :living_area_id, :advisor_id, :year, :gender, :major, :created_at, :updated_at
json.url student_url(student, format: :json)
