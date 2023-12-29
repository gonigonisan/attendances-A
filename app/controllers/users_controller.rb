class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show

  def index
    @users = User.all
  end
  
  def import
    if File.extname(params[:file].original_filename) == ".csv"
      flash[:success] = 'CSVファイルを読み込みました'
      User.import(params[:file])
      redirect_to users_url
    else
      flash[:danger] = 'CSVファイルを選択してください'
      @users = User.all
      redirect_to users_url
    end
  end

  def show
    # 1ヶ月分の勤怠データの中で、出勤時間が何も無い状態では無いものの数を代入
    @worked_sum = @attendances.where.not(started_at: nil).
    @superior = User.where(superior: true).where.not(id: current_user.id)
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
    @attendances = @user.attendances.where(worked_on: 
    @first_day..@last_day).order(:worked_on)
    unless one_month.count == @attendances.count
      ActiveRecord::Base.transaction do
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "ページ情報の取得に失敗しました"
      redirect_to root_url
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    @user = User.find(params[:id])
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}さんの基本情報を更新しました。"
    else
      @user = User.find(params[:id])
      flash[:danger] = "#{@user.name}さんの更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
    
  def index_attendance
    @now_users = []
    @now_users_employee_number = []
    User.all.each do |user|
      if user.attendances.any?{|day|
         ( day.worked_on == Date.today &&
           !day.started_at.blank? &&
           day.finished_at.blank? )
          }
        @now_users.push(user.name)
        @now_users_employee_number.push(user.employee_number)
      end
    end
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :uid, :affiliation, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:name, :email, :affiliation, :uid, :employee_number, :password, :password_confirmation, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end
end
