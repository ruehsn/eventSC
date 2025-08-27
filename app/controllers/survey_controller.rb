class SurveyController < ApplicationController
  def index
    @survey_month  = params[:survey_month] || Date.today.strftime("%Y-%m")
    if params[:student_id]
      @student = Student.includes(:event_options).find(params[:student_id])
    else
      @student = Student.includes(:event_options).first # Default to first student for index
    end
    @events  = Event.where(survey_month: @survey_month).includes(:event_options)
  end

  def show
    @survey_month  = params[:survey_month] || Date.today.strftime("%Y-%m")
    @event = Event.find(params[:id])
    @events = [ @event ] # Show single event
  end

  def submit
    student = Student.find(params[:student_id])
    selected_event_option_ids = params[:event_option_ids] || {}

    # Add new selections
    selected_event_option_ids.each_pair do |event_id, event_option_id|
      event       = Event.find(event_id)
      eventOption = EventOption.find(event_option_id)
      s = StudentEventOption.find_or_initialize_by(student: student, event: event)
      s.event_option_id = eventOption.id
      s.save!
      pp "Saving #{student.id} #{eventOption.id} #{event.id}"
    end

    redirect_to survey_path, notice: "Survey submitted successfully!"
  end
end
