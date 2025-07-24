class AdvisorsController < ApplicationController
  before_action :set_advisor, only: %i[ show edit update destroy ]

  # GET /advisors or /advisors.json
  def index
    @advisors = Advisor.all
  end

  # GET /advisors/1 or /advisors/1.json
  def show
    @advisor = Advisor.find(params[:id])
    @upcoming_events = Event.upcoming
                         .joins(:event_options)
                         .merge(EventOption.yes_options)
                         .includes(:event_options)
                         .distinct
  end

  # GET /advisors/new
  def new
    @advisor = Advisor.new
  end

  # GET /advisors/1/edit
  def edit
  end

  # POST /advisors or /advisors.json
  def create
    @advisor = Advisor.new(advisor_params)

    respond_to do |format|
      if @advisor.save
        format.html { redirect_to @advisor, notice: "Advisor was successfully created." }
        format.json { render :show, status: :created, location: @advisor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @advisor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /advisors/1 or /advisors/1.json
  def update
    respond_to do |format|
      if @advisor.update(advisor_params)
        format.html { redirect_to @advisor, notice: "Advisor was successfully updated." }
        format.json { render :show, status: :ok, location: @advisor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @advisor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advisors/1 or /advisors/1.json
  def destroy
    @advisor.destroy!

    respond_to do |format|
      format.html { redirect_to advisors_path, status: :see_other, notice: "Advisor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def students
    @advisor = Advisor.find(params[:id])
    @students = @advisor.students.includes(:events, student_event_options: :event_option)
    @survey_results = @students.map do |student|
      {
        student: student,
         events: student.events.map do |event|
          {
            event: event,
            event_option: student.student_event_options.find_by(event: event).event_option
          }
        end
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advisor
      @advisor = Advisor.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def advisor_params
      params.expect(advisor: [ :first_name, :last_name, :email ])
    end
end
