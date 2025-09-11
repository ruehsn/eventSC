class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy event_signup submit_event_options send_parent_email_now ]
  before_action :require_admin, only: %i[ new create edit update destroy send_parent_email_now bulk_upload process_bulk_upload ]

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
      s = StudentEventOption.find_or_initialize_by(student: @student, event: event)
      s.event_option_id = eventOption.id
      s.save!
      pp "Saving #{@student.id} #{eventOption.id} #{event.id}"
    end

    # Send confirmation email to parent (delayed)
    if @student.parent_email.present?
      if ! Rails.env.production?
        ParentMailer.event_signup_confirmation(@student, Current.user.email).deliver_now
      else
        # TODO: Re-enable once prod SMTP service is established
        # ParentMailer.event_signup_confirmation(@student).deliver_now
        # DelayedParentEmailService.schedule_email(@student)
        # note: in production we delay/skip sending until SMTP is configured
      end
    end

    # After saving, return the user to the referring page when possible.
    # `event_signup` stores the referer in session[:return_to]. Use redirect_back with a sensible fallback.
    return_to = session.delete(:return_to)
    notice_msg = "Event selections saved."
    if return_to.present?
      redirect_to return_to, notice: notice_msg
    else
      redirect_back fallback_location: student_path(@student), notice: notice_msg
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

  # GET /students/bulk_upload
  def bulk_upload
    # Show the bulk upload form
  end

  # POST /students/process_bulk_upload  
  def process_bulk_upload
    unless params[:photos].present?
      redirect_to bulk_upload_students_path, alert: "Please select photos to upload."
      return
    end

    results = { success: [], failed: [] }
    
    # Filter out empty strings and non-file objects
    valid_photos = params[:photos].select { |photo| photo.present? && photo.respond_to?(:original_filename) }
    
    valid_photos.each do |photo|
      # Extract student identifier from filename (before the file extension)
      filename = File.basename(photo.original_filename, File.extname(photo.original_filename))
      
      # Try to find student by short_name, first_name, or last_name
      student = find_student_by_identifier(filename)
      
      if student
        begin
          # Attach the photo (this will trigger automatic processing via the model callback)
          student.photo.attach(photo)
          results[:success] << { student: student.display_name, filename: photo.original_filename }
        rescue => e
          results[:failed] << { filename: photo.original_filename, error: e.message }
        end
      else
        results[:failed] << { filename: photo.original_filename, error: "Student not found" }
      end
    end

    flash[:notice] = "Uploaded #{results[:success].count} photos successfully."
    flash[:alert] = "Failed to upload #{results[:failed].count} photos." if results[:failed].any?
    
    redirect_to bulk_upload_students_path, notice: "Bulk upload completed. #{results[:success].count} successful, #{results[:failed].count} failed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:short_name, :first_name, :last_name, :notes_url, :living_area_id, :advisor_id, :year, :gender, :major, :parent_email, :photo, :student_life_holds_cash)
    end

    def require_admin
      unless Current.user&.admin?
        redirect_to students_path, alert: "Admin access required."
      end
    end

    def find_student_by_identifier(identifier)
      # Clean the identifier (remove common separators and normalize)
      clean_id = identifier.gsub(/[-_\s]+/, ' ').strip.downcase
      
      # Try exact match on short_name first
      student = Student.find_by("LOWER(short_name) = ?", clean_id)
      return student if student

      # Try partial matches
      Student.where(
        "LOWER(short_name) LIKE ? OR LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(CONCAT(first_name, ' ', last_name)) LIKE ?",
        "%#{clean_id}%", "%#{clean_id}%", "%#{clean_id}%", "%#{clean_id}%"
      ).first
    end
end
