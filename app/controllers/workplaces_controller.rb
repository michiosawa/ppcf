class WorkplacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workplace, only: %i[ show edit update destroy ]

  # GET /workplaces or /workplaces.json
  def index
    @workplaces = Workplace.all
  end

  # GET /workplaces/1 or /workplaces/1.json
  def show
    @month_workdays = Workday.where(workplace_id: @workplace.id, checkin: Date.current.all_month)
    @groupby_date = @month_workdays.group_by { |wd| wd.checkin.to_date }
  end

  # GET /workplaces/new
  def new
    @workplace = Workplace.new
  end

  # GET /workplaces/1/edit
  def edit
  end

  # POST /workplaces or /workplaces.json
  def create
    @workplace = Workplace.new(workplace_params)
    respond_to do |format|
      if @workplace.save
        format.html { redirect_to @workplace, notice: "Workplace was successfully created." }
        format.json { render :show, status: :created, location: @workplace }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @workplace.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /workplaces/1 or /workplaces/1.json
  def update
    respond_to do |format|
      if @workplace.update(workplace_params)
        format.html { redirect_to @workplace, notice: "Workplace was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @workplace }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @workplace.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /workplaces/1 or /workplaces/1.json
  def destroy
    @workplace.destroy!

    respond_to do |format|
      format.html { redirect_to workplaces_main_path, notice: "Workplace was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workplace
      @workplace = Workplace.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def workplace_params
      params.expect(workplace: [ :title, :manager, :address, :comment ])
    end
end
