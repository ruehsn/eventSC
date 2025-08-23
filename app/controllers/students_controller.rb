class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy event_signup submit_event_options send_parent_email_now ]
  before_action :require_admin, only: %i[ new create edit update destroy send_parent_email_now ]

  # GET /students or /students.json
  def index
    @students = Student.all.includes(:living_area, :advisor)
  end

  # GET /students/1 or /students/1.json
  def show
    @student = Student.includes(:living_area, :advisor, student_event_options: :event_option).find(params[:id])
  end

  # GET /students/new
  def new
    @student = Student.new
    @living_areas = LivingArea.all
  end

  # GET /students/1/edit
  def edit
    @living_areas = LivingArea.all
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy!

    respond_to do |format|
      format.html { redirect_to students_path, status: :see_other, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def event_signup
    @student          = Student.find(params[:id])
    @upcoming_events  = Event.upcoming.includes(event_options: :student_event_options)


    @selected_options = @student.student_event_options.pluck(:event_option_id)
    session[:return_to] = request.referer if request.referer.present?
  end

  def submit_event_options
    @student = Student.find(params[:id])
    selected_options = params[:event_options] || {}

    selected_options.each_pair do |event_id, event_option_id|
      event       = Event.find(event_id)
      eventOption = EventOption.find(event_option_id)
      s = StudentEventOption.find_or_initialize_by(student: @student, event:event)
      s.event_option_id = eventOption.id
      s.save!
      pp "Saving #{@student.id} #{eventOption.id} #{event.id}"
    end

    # Send confirmation email to parent (delayed)
    if @student.parent_email.present?
      if ! Rails.env.production?
        ParentMailer.event_signup_confirmation(@student, Current.user.email).deliver_now
      else
        ParentMailer.event_signup_confirmation(@student).deliver_now
        # DelayedParentEmailService.schedule_email(@student)
        # redirect_to student_path(@student), notice: "Event selections saved. Parent email will be sent in 2 hours."
      end
      redirect_to student_path(@student), notice: "Event selections saved. Parent email has been sent."
    else
      redirect_to student_path(@student), notice: "Event selections saved."
    end
  end

  def send_parent_email_now
    if @student.parent_email.present?
      DelayedParentEmailService.send_immediately(@student)
      redirect_to @student, notice: "Parent email sent immediately to #{@student.parent_email}"
    else
      redirect_to @student, alert: "No parent email address on file for this student."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:short_name, :first_name, :last_name, :notes_url, :living_area_id, :advisor_id, :year, :gender, :major, :parent_email)
    end

    def require_admin
      unless Current.user&.admin?
        redirect_to students_path, alert: "Admin access required."
      end
    end
end
