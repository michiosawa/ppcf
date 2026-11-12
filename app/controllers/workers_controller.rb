class WorkersController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_worker, only: %i[ show edit update destroy ]

  # GET /workers or /workers.json
  def index
    @workers = Worker.all
  end

  # GET /workers/1 or /workers/1.json
  def show
    @worker = Worker.find_by!(access_token: params[:access_token])
  end

  def show_qr
    @worker = Worker.find_by!(access_token: params[:access_token])
    @lan_ip = Socket.ip_address_list.detect(&:ipv4_private?).ip_address
  end

  def regenerate_token
    @worker = Worker.find_by!(access_token: params[:access_token])
    @worker.regenerate_access_token!
    redirect_to worker_qr_path(@worker.access_token), notice: "Access token regenerated successfully."
  end
  # GET /workers/new
  def new
    @worker = Worker.new
    @companies = Company.all
  end
  # POST /workers or /workers.json
  def create
    @companies = Company.all
    @worker = Worker.new(worker_params)
    @worker.company_id = params[:worker][:company_id]
    if @worker.save
      redirect_to worker_path(@worker.access_token), notice: "Worker was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end
  # GET /workers/1/edit
  def edit
    @companies = Company.all
    @worker = Worker.find_by!(access_token: params[:access_token])
  end
  # PATCH/PUT /workers/1 or /workers/1.json
  def update
    @worker = Worker.find_by!(access_token: params[:access_token])

    if @worker.update(worker_params)
      redirect_to worker_path(@worker.access_token), notice: "Worker was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /workers/1 or /workers/1.json
  def destroy
    @worker = Worker.find_by!(access_token: params[:access_token])
    @worker.destroy!
    respond_to do |format|
      format.html { redirect_to workers_main_path, notice: "Worker was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_worker
    #   @worker = Worker.find_by(access_token: params.expect(:access_token))
    # end

    # Only allow a list of trusted parameters through.
    def worker_params
      params.expect(worker: [ :name, :company_id, :tel, :last, :access_token, :etc ])
    end
end
