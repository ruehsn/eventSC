class Event < ApplicationRecord
    has_many :event_options,  dependent: :destroy
    has_many :student_event_options, dependent: :destroy
    has_many :students, through: :student_event_options
    accepts_nested_attributes_for :event_options, allow_destroy: true, reject_if: :all_blank

    validates :name, :date, presence: true
        attr_accessor :no_thanks, :off_campus
    
    scope :upcoming, -> { where("date >= ?", Date.today).order(:date) }
    scope :past,     -> { where("date <  ?", Date.today).order(date: :desc) }

    def cash_to_sc_office(advisor_id = nil)
        student_life_managed_students(advisor_id).to_a.union(
        sc_office_managed_cash_event(advisor_id).to_a)
    end

    def sc_office_managed_cash_event(advisor_id = nil)
        query = Student.joins(:advisor, student_event_options: :event_option)
            .select('students.*, advisors.last_name AS advisor, 
                    event_options.description AS event_option_description, 
                    event_options.cost AS event_option_cost')
            .where(student_event_options: {
                event_option_id: EventOption.where(office_holds_cash: true)
                                            .where('cost > 0')
                                            .where(event_id: id)
                                            .select(:id)
            })
        
        query = query.where(advisor_id: advisor_id) if advisor_id.present?
        query  
    end

    def student_life_managed_students(advisor_id = nil)
        query = Student.joins(:advisor, student_event_options: :event_option)
            .select('students.*, advisors.last_name AS advisor, 
                    event_options.description AS event_option_description, 
                    event_options.cost AS event_option_cost')
            .where(student_event_options: {
                event_option_id: EventOption.where(office_holds_cash: false)
                                            .where('cost > 0')
                                            .where(event_id: id)
                                            .select(:id)
            })
            .where(student_life_holds_cash: true)
        
        query = query.where(advisor_id: advisor_id) if advisor_id.present?
        query
    end

    def cash_to_students(advisor_id = nil)
        query = Student.joins(:advisor, student_event_options: :event_option)
               .select('students.*, advisors.last_name AS advisor, 
                       event_options.description AS event_option_description, 
                       event_options.cost AS event_option_cost')
               .where(student_event_options: {
                   event_option_id: EventOption.where(office_holds_cash: false)
                                             .where('cost > 0')
                                             .where(event_id: id)
                                             .select(:id)
               })
               .where(student_life_holds_cash: false)
        
        query = query.where(advisor_id: advisor_id) if advisor_id.present?
        return query
    end

    private

end