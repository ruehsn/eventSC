class Student < ApplicationRecord
    belongs_to :advisor
    belongs_to :living_area
    belongs_to :room, optional: true
    has_many :student_event_options, dependent: :destroy
    has_many :events,        through: :student_event_options
    has_many :event_options, through: :student_event_options
    
    has_one_attached :photo

    validates :short_name, presence: true, uniqueness: true

    # Adding a new boolean attribute with a default value of false
    attribute :student_life_holds_cash, :boolean, default: false

    def self.students_with_cash_for_event_option(event_id)
        Student.joins(student_event_options: :event_option)
               .where("event_options.cost > 0")
               .where(event_options: { office_holds_cash: true })
               .where(students: { student_life_holds_cash: true })
               .where(student_event_options: { event_id: event_id })
    end
    
    def photo_url
      return nil unless photo.attached?
      Rails.application.routes.url_helpers.rails_blob_path(photo, only_path: true)
    end
    
    def display_name
      "#{first_name} #{last_name}".strip
    end
end
