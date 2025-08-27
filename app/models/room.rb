class Room < ApplicationRecord
  belongs_to :living_area
  has_many :students, dependent: :nullify
  
  validates :room_number, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :x_position, :y_position, :width, :height, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  scope :with_available_space, -> { joins(:students).group(:id).having('COUNT(students.id) < capacity') }
  
  def available_spaces
    capacity - students.count
  end
  
  def full?
    students.count >= capacity
  end
end
