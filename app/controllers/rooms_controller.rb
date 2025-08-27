class RoomsController < ApplicationController
  before_action :require_admin
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :set_living_area, only: [:index, :new, :create]

  def index
    @rooms = @living_area.rooms.includes(:students)
  end

  def show
  end

  def new
    @room = @living_area.rooms.build
  end

  def create
    @room = @living_area.rooms.build(room_params)
    
    if @room.save
      redirect_to rooms_path(living_area_id: @living_area.id), notice: 'Room was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @room.update(room_params)
      redirect_to room_path(@room), notice: 'Room was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    living_area = @room.living_area
    @room.destroy
    redirect_to rooms_path(living_area_id: living_area.id), notice: 'Room was successfully deleted.'
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def set_living_area
    @living_area = LivingArea.find(params[:living_area_id]) if params[:living_area_id]
  end

  def room_params
    params.require(:room).permit(:room_number, :capacity, :x_position, :y_position, :width, :height)
  end

  def require_admin
    unless Current.user&.admin?
      redirect_to root_path, alert: "Admin access required."
    end
  end
end
