class EventOption < ApplicationRecord
  belongs_to :event
  has_many :student_event_options, dependent: :destroy
  has_many :students, through: :student_event_options

  scope :yes_options, -> { 
    where.not("LOWER(description) LIKE ? OR LOWER(description) LIKE ?", "%no, thanks%", "%off campus%")
  }

  def self.fetch_event_options
    EventOption.joins(:event).where("event_options.cost > 0 AND event_options.office_holds_cash = ? AND events.student_life_holds_cash = ?", true, false)
  end
end
