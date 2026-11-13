class WorkdaysController < ApplicationController
  before_action :authenticate_user!, except: [ :check, :checkin, :checkout ]
  # before_action :set_workday, only: %i[ show edit update destroy ]

  # GET /workdays or /workdays.json
  def index
    @date = Date.parse(params[:id]).all_day
    @workday = Workday.all.where(checkin: @date)
    @grouped_workdays = @workday.group_by { |wd| wd.workplace.title }
  end

  # GET /workdays/1 or /workdays/1.json
  def show
    @workday = Workday.find(params[:id])
  end

  # GET /workdays/new
  def new
    @worker = Worker.find_by!(access_token: params[:access_token])
    @workday = Workday.new
  end

  def create
    @worker = Worker.find_by!(access_token: params[:access_token])

    wday_parse = Date.parse(workday_params[:date]).all_day

    @check_workday = Workday.find_by(worker_id: @worker.id, checkin: wday_parse)

    if @check_workday


      redirect_to worker_path(@worker.access_token), notice: "Workday for this date already exists."
    else
        @last_workday = Workday.where(worker_id: @worker.id).order(checkin: :desc).first
        @last_workplace = @last_workday ? @last_workday.workplace : Workplace.all.first

        cin = Time.parse("#{workday_params[:date]} 08:00")
        cout = Time.parse("#{workday_params[:date]} 17:00")

        @workday = Workday.new(
          worker_id: @worker.id,
          checkin: cin,
          checkout: cout,
          workplace_id: @last_workplace.id,
          )

      if @workday.save
        redirect_to worker_path(@workday.worker.access_token), notice: "Workday was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def check
    @worker = Worker.find_by(access_token: params[:access_token])
    @workday = Workday.find_by(worker_id: @worker.id, checkin: Date.today.all_day)
    @workplace = Workplace.all
    @last_workday = Workday.find_by(id: @worker.last)
    @last_workplace = @last_workday ? @last_workday.workplace : Workplace.all.first
    @last_healthcheck = { pressure1: [ 0, 0 ], pressure2: [ 0, 0 ], temp1: 0, temp2: 0 }
    if @last_workday
      @last_healthcheck = @last_workday.healthcheck
    end
  end

  def checkin
    time = Time.current
    @worker = Worker.find_by(access_token: params[:access_token])
    @workday = Workday.find_by(worker_id: @worker.id, checkin: Date.current.all_day)
    if @last_workday
      @last_healthcheck = @last_workday.healthcheck
    end
    if @worker.nil?
      redirect_to workers_main_path, alert: "Worker not found."
    end
    if @workday
      redirect_to workday_checkout_path(worker_id: @worker.access_token), alert: "You have already checked in today."
    else
      workplace = workday_params[:workplace_id].present? ? Workplace.find_by(id: workday_params[:workplace_id]) : Workplace.all.first
      healthcheck = {
        pressure1: [ workday_params[:maxp], workday_params[:minp] ],

        temp1: workday_params[:temp],

        checkboxes: { check_1: workday_params[:ck1], check_2: workday_params[:ck2], check_3: workday_params[:ck3], check_4: workday_params[:ck4] },
        alcohol: workday_params[:alcohol]
        }
      @workday = Workday.new(
        worker_id: @worker.id,
        checkin: time,
        workplace_id: workplace.id,
        healthcheck: healthcheck
        )
      if @workday.save
        redirect_to checkin_path(@worker.access_token), notice: "Check-in successful."
      else
        redirect_to worker_path(@worker.access_token), alert: "Check-in failed."
      end
    end
  end
  # GET /workdays/1/edit
  def checkout
    time = Time.current
    if time > Time.zone.parse("14:00") && time < Time.zone.parse("17:00")
      time = Time.zone.parse("17:00")
    end
    @worker = Worker.find_by(access_token: params[:access_token])
    @workday = Workday.find_by(worker_id: @worker.id, checkin: Date.current.all_day)
    if @workday.nil?
      redirect_to workers_main_path, alert: "No check-in record found for today."
    else
      @workday.checkout = time
      checkboxes = { check_5: workday_params[:ck1], check_6: workday_params[:ck2], check_7: workday_params[:ck3], check_8: workday_params[:ck4] }
      healthcheck = {
        pressure2: [ workday_params[:maxp], workday_params[:minp] ],
        temp2: workday_params[:temp]
      }
      @workday.healthcheck["pressure2"] = [ workday_params[:maxp], workday_params[:minp] ]
      @workday.healthcheck["temp2"] = workday_params[:temp]
      @workday.healthcheck["checkboxes"].merge!(checkboxes)
      @workday.overtime = workday_params[:overtime] if workday_params[:overtime].present?
      if @workday.save
        @worker.last = @workday.id
        @worker.save
        redirect_to checkin_path(@worker.access_token), notice: "Check-out successful."
      else
        redirect_to workers_main_path(id: Date.current), alert: "Check-out failed."
      end
    end
  end
  # POST /workdays or /workdays.json
  def edit
    @workday = Workday.find(params[:id])
    @workers = Worker.find(@workday.worker_id)
    @start = @workday.checkin
    @end = @workday.checkout
    @overtime = @workday.overtime ? @workday.overtime : 0
  end
  # PATCH/PUT /workdays/1 or /workdays/1.json
  def update
    @workday = Workday.find(params[:id])
    @update = {
      checkin: "#{workday_params[:checkin]}",
      checkout: "#{workday_params[:checkout]}",
      overtime: workday_params[:overtime]
    }
    if @workday.update(@update)

      redirect_to workday_path(@workday), notice: "Workday updated successfully."
    else
      redirect_to workday_edit_path(@workday), alert: "Failed to update workday."
      render :edit_workday, status: :unprocessable_entity
    end
  end

  # DELETE /workdays/1 or /workdays/1.json
  def destroy
    @worker = Worker.find_by(access_token: params[:access_token])
    @workday = Workday.find(params[:id])
    @workday.destroy!

    respond_to do |format|
      format.html { redirect_to workdays_main_path(id: Date.today), notice: "Workday was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  # def set_workday
  #   @workday = Workday.find(params.expect(:id))
  # end

  # Only allow a list of trusted parameters through.
  def workday_params
    params.expect(workday: [ :worker_id, :workplace_id, :access_token, :date, :checkin, :checkout, :healthcheck, :overtime, :comment, :maxp, :minp, :temp, :ck1, :ck2, :ck3, :ck4, :alcohol ])
  end
end
