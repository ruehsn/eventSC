class LivingArea < ApplicationRecord
    has_many :students
    has_many :rooms, dependent: :destroy
    
    validates :name, presence: true, uniqueness: true
    
    def total_capacity
      rooms.sum(:capacity)
    end
    
    def occupied_spaces
      students.count
    end
    
    def available_spaces
      total_capacity - occupied_spaces
    end
end
