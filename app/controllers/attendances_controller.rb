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
  
  def edit_overtime_request
    # debugger
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:attendance_id])
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
    
    # モーダルの情報
    def overtime_params
      params.require(:attendance).permit(:overtime_finished_at, :next_day, :overtime_work,:indicater_check)
    end
end