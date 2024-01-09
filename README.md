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