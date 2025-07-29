class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]

  # GET /events or /events.json
  def index
    @events = Event.includes(event_options: :student_event_options)
  end

  # GET /events/1 or /events/1.json
  def show
    @event = Event.find(params[:id])
    @students_by_living_area_and_option = @event.student_event_options
        .includes({student: :living_area}, :event_option)
        .group_by { |se| [se.student.living_area, se.event_option] }
    @missing_students = Student.includes(:living_area).where.not(id: @event.students.pluck(:id))

    @total_sc_office_cash = @event.cash_to_sc_office.sum { |student| student.event_option_cost }
    @total_student_cash   = @event.cash_to_students.sum { |student| student.event_option_cost }
  end

  # GET /events/new
  def new
    @event = Event.new
    @event.event_options.build # Prebuild an empty event option
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    
    Rails.logger.debug "============================================================================="
    Rails.logger.debug "Params received:     "+ params.inspect
    Rails.logger.debug "Event options built: "+ @event.event_options.inspect
    Rails.logger.debug "Event options built: "+ params[:event].inspect
    Rails.logger.debug "Event options built: "+ params[:event][:no_thanks].inspect
    
    if params[:event][:no_thanks] == "true"
      Rails.logger.debug "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~no thanks option selected"
      @event.event_options.build(description: "No, thanks", cost: 0, office_holds_cash: true, transportation_required: false)
    end

    if params[:event][:off_campus] == "true"
      @event.event_options.build(description: "Off Campus", cost: 0, office_holds_cash: true, transportation_required: false)
    end

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to events_path, status: :see_other, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def cash_office
    @event      = Event.find(params[:id])
    @advisor_id = params[:advisor_id]
    rescue ActiveRecord::RecordNotFound
    redirect_to events_path, alert: 'Event not found'
  end

  def student_cash
    @event = Event.find(params[:id])
    @advisor_id = params[:advisor_id]
  rescue ActiveRecord::RecordNotFound
    redirect_to events_path, alert: 'Event not found'
  end
  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :name, 
      :date, 
      :survey_month,
      :no_thanks,
      :off_campus,
      event_options_attributes: [
        :id, 
        :description, 
        :cost, 
        :office_holds_cash, 
        :transportation_required,
        :leave_time,
        :return_time,
        :_destroy
      ]
    )
  end
end
