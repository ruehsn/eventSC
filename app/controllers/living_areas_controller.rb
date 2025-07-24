class LivingAreasController < ApplicationController
  before_action :set_living_area, only: %i[ show edit update destroy ]

  # GET /living_areas or /living_areas.json
  def index
    @living_areas = LivingArea.all
  end

  # GET /living_areas/1 or /living_areas/1.json
  def show
  end

  # GET /living_areas/new
  def new
    @living_area = LivingArea.new
  end

  # GET /living_areas/1/edit
  def edit
  end

  # POST /living_areas or /living_areas.json
  def create
    @living_area = LivingArea.new(living_area_params)

    respond_to do |format|
      if @living_area.save
        format.html { redirect_to @living_area, notice: "Living area was successfully created." }
        format.json { render :show, status: :created, location: @living_area }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @living_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /living_areas/1 or /living_areas/1.json
  def update
    respond_to do |format|
      if @living_area.update(living_area_params)
        format.html { redirect_to @living_area, notice: "Living area was successfully updated." }
        format.json { render :show, status: :ok, location: @living_area }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @living_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /living_areas/1 or /living_areas/1.json
  def destroy
    @living_area.destroy!

    respond_to do |format|
      format.html { redirect_to living_areas_path, status: :see_other, notice: "Living area was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_living_area
      @living_area = LivingArea.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def living_area_params
      params.expect(living_area: [ :name, :description ])
    end
end
