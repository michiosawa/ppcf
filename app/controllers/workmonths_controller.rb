class WorkmonthsController < ApplicationController
  before_action :set_workmonth, only: %i[ show edit update destroy ]

  # GET /workmonths or /workmonths.json
  def index
    @workmonths = Workmonth.all
  end

  # GET /workmonths/1 or /workmonths/1.json
  def show
  end

  # GET /workmonths/new
  def new
    @workmonth = Workmonth.new
  end

  # GET /workmonths/1/edit
  def edit
  end

  # POST /workmonths or /workmonths.json
  def create
    @workmonth = Workmonth.new(workmonth_params)

    respond_to do |format|
      if @workmonth.save
        format.html { redirect_to @workmonth, notice: "Workmonth was successfully created." }
        format.json { render :show, status: :created, location: @workmonth }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @workmonth.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /workmonths/1 or /workmonths/1.json
  def update
    respond_to do |format|
      if @workmonth.update(workmonth_params)
        format.html { redirect_to @workmonth, notice: "Workmonth was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @workmonth }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @workmonth.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /workmonths/1 or /workmonths/1.json
  def destroy
    @workmonth.destroy!

    respond_to do |format|
      format.html { redirect_to workmonths_path, notice: "Workmonth was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workmonth
      @workmonth = Workmonth.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def workmonth_params
      params.expect(workmonth: [ :month, :workplace_id, :entries, :comment ])
    end
end
