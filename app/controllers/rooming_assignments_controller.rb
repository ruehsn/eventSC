class RoomingAssignmentsController < ApplicationController
  before_action :require_admin
  before_action :set_living_area, only: [:show, :edit, :update]

  def index
    @living_areas = LivingArea.includes(:rooms, :students).all
  end

  def show
    @students_without_rooms = @living_area.students.where(room: nil)
    @students_with_rooms = @living_area.students.where.not(room: nil).includes(:room)
  end

  def edit
    @students_without_rooms = @living_area.students.where(room: nil)
    @students_with_rooms = @living_area.students.where.not(room: nil).includes(:room)
  end

  def update
    assignments = params[:assignments] || {}
    
    ActiveRecord::Base.transaction do
      assignments.each do |student_id, room_id|
        student = Student.find(student_id)
        if room_id.present? && room_id != "unassigned"
          room = Room.find(room_id)
          # Check room capacity
          if room.available_spaces > 0 || student.room_id == room.id
            student.update!(room: room)
          else
            flash[:alert] = "Room #{room.room_number} is at capacity"
            raise ActiveRecord::Rollback
          end
        else
          student.update!(room: nil)
        end
      end
    end
    
    redirect_to rooming_assignment_path(@living_area), notice: 'Room assignments updated successfully.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to edit_rooming_assignment_path(@living_area), alert: "Error updating assignments: #{e.message}"
  end

  private

  def set_living_area
    @living_area = LivingArea.includes(:rooms, :students).find(params[:id])
  end

  def require_admin
    unless Current.user&.admin?
      redirect_to root_path, alert: "Admin access required."
    end
  end
end
