class PagesController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]

  def index
    @users = User.first
  end

  def thmain
    @month_calendar = calendar(Date.today.to_s)
    @weeks = @month_calendar
    @week_format = [ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ]
  end

  def new_user
    @user = User.new
  end

  def create_user
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "User created successfully."
    else
      render :new_user
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def calendar(date)
    file_path = Rails.root.join("public", "month.json")
    json_string = File.read(file_path)
    file_data = JSON.parse(json_string)
    if file_data["month"] == Date.today.month
      file_data
    else
      today = Date.parse(date)
      mon = today.mon - 1

      pmon = mon == 0 ? 11 : mon - 1

      nmon = mon == 11 ? 0 : mon + 1

      year = [
        31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
      ]

      firstday = "#{today.year}-#{(mon + 1)}-1"
      wday = Date.parse(firstday).wday
      wday = wday.positive? ? wday - 1 : 6

      premon = ((year[pmon] - wday)..year[pmon]).to_a

      premon.map! { |d| "#{(pmon + 1)}/#{d}" }

      cmon = (1..year[mon]).to_a
      cmon.map! { |d| "#{mon + 1}/#{d}" }

      nexmon = (1..14).to_a
      nexmon.map! { |d| "#{(nmon + 1)}/#{d}" }

      fmon = premon + cmon + nexmon

      mon_arr = [ fmon[0..6], fmon[7..13], fmon[14..20], fmon[21..27], fmon[28..34], fmon[35..41] ]

      mounth_data = {
        "month": mon + 1,
        "weeks": mon_arr
      }
      mounth_JSON = JSON.generate(mounth_data)
      File.open(file_path, "w") do |file|
        file.write(mounth_JSON)
      end
      mounth_JSON
    end
  end
end
