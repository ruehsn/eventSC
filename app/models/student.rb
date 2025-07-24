class Student < ApplicationRecord
    belongs_to :advisor
    belongs_to :living_area
    has_many :student_event_options, dependent: :destroy
    has_many :events,        through: :student_event_options
    has_many :event_options, through: :student_event_options

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
end
