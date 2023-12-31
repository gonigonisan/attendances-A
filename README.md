class AppliesController < ApplicationController
  
  # 上長A 1ヶ月分の勤怠申請
  def index1
    # debugger
    # @user = User.find(params[:user_id])
    # @attendance = Attendance.find(params[:attendance_id])
    # @adomin = User.where(admin: true).where.not( id: current_user.id )
    # @applies = Apply.where(attendance_id: params[:attendance_id])
    @zyoutyouas = Apply.where(instructor_test: 1)
  end
  
  # 上長2 1ヶ月分の勤怠申請
  def index2
    # debugger
    # @user = User.find(params[:user_id])
    # @attendance = Attendance.find(params[:attendance_id])
    # @adomin = User.where(admin: true).where.not( id: current_user.id )
    # @applies = Apply.where(attendance_id: params[:attendance_id])
    @zyoutyoubs = Apply.where(instructor_test: 2)
  end
  
  def new
    @apply = Apply.new
  end
  
  def create
    @apply = Apply.new(apply_params)
    @apply.user_id = current_user.id
    current_user.applies.create(attendance_id: apply_params[:attendance_id])
    flash[:success] = "申請しました。"
    redirect_to current_user
  end

  private

    def apply_params
      params.permit(:instructor_test, :user_id, :attendance_id)
    end
end
