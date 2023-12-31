class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        # item[:started_at]とitem[:finished_at]がない場合、次に行く
        unless item[:started_at].present? && item[:finished_at].present?
          next;
        end
        if item[:next_day] == 'true'
          # item[:finished_at] を文字列から Time に変換
          item[:finished_at] = Time.zone.parse(item[:finished_at])
          # item[:finished_at] に 24 時間を加算
          item[:finished_at] += 24.hours
        end
        attendance.update!(item)
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  # 1ヶ月分の勤怠承認
  def edit_month_approval
    @user = User.find(params[:id])
    @users = User.joins(:attendances).group("users.id").where(attendances: {indicater_reply_month: "申請中"})
    @attendances = Attendance.where.not(month_approval:nil).order("worked_on ASC")
    @first_day = params[:date].nil? ?
     Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
      unless one_month.count == @attendances.count
        ActiveRecord::Base.transaction do
          one_month.each { |day| @user.attendances.create!(worked_on: day) }
        end
        @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
      end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end  
    
  # 1ヶ月分の申請
  def update_month_approval
    @user = User.find(params[:id])
    @attendance = Attendance.find(params[:id])
    @superior = User.where(superior: true).where.not( id: current_user.id )
    if @attendance.update_attributes(month_approval_params)
      flash[:success] = "勤怠申請を受け付けました"
      redirect_to user_url(@user)
    end  
  end 
  
  # 申請モーダル
  def edit_overtime_request
    # debugger
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:attendance_id])
    @adomin = User.where(admin: true).where.not( id: current_user.id )
  end
  
  def update_overtime_request
    # 取得できるものは以下と同じ @user = User.find(params[:id])
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:attendance_id])
    # binding.pry
    if params[:attendance][:overtime_finished_at].blank? || params[:attendance][:indicater_check].blank?
      flash[:dager] = "必須箇所が空欄です。"
      redirect_to @user
    else
      @attendance.update_attributes(overtime_params)
      flash[:success] = "残業申請が完了しました。"
      redirect_to @user and return
    end
  end
  
  private
    # １ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :next_day, :note])[:attendances]
    end
    # beforeフィルター

    # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end  
    end
    
    def month_approval_params 
      # attendanceテーブルの（承認月,指示者確認、どの上司か）
      params.require(:user).permit(attendances: [:month_approval, :indicater_reply_month, :indicater_check_month])[:attendances]
    end
    
    # 申請モーダルの情報
    def overtime_params
      params.require(:attendance).permit(:overtime_finished_at, :next_day, :overtime_work,:indicater_check, :indicater_check_superior)
    end
    
    # 申請お知らせモーダルの情報
    def overtime_notice_params
    end
end