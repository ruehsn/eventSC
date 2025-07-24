class StudentEventOption < ApplicationRecord
  belongs_to :student
  belongs_to :event
  belongs_to :event_option
end
