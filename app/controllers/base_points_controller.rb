class BasePointsController < ApplicationController
  before_action :admin_user, only: [:new, :create, :edit, :update, :index, :show, :destroy]
  before_action :set_base_point, only: [:edit, :update, :destroy]
  
  def new
    @base_point = BasePoint.new
  end
  
  def create
    @base_point = BasePoint.new(base_point_params)
    if @base_point.save
      flash[:seccess] = "拠点登録完了しました。"
      redirect_to base_points_url
    else
      flash[:danger] = "拠点情報の作成に失敗しました。" +  @base_point.errors.full_messages.join("<br>")
      redirect_to base_points_url
    end
  end  
    
  def edit
  end
  
  def update
    if @base_point.update_attributes(base_point_params)
      flash[:success] = "拠点情報を修正しました。"
      redirect_to base_points_url
    else
      flash[:danger] = "拠点情報の修正に失敗しました。" + @base.errors.full_messages.join("<br>")
      redirect_to base_points_url
    end
  end  
  
  def index
    @base_points = BasePoint.all
  end

  def show
  end

  def destroy
    @base_point.destroy
    flash[:success] = "#{@base_point.base_name}のデータを削除しました。"
    edirect_to base_points_url
  end
  
  private
  
    def set_base_point
      @base_point = BasePoint.find(params[:id])
    end
  
    def base_point_params
      params.require(:base_point).permit(:base_name, :base_number, :information)
    end    
end
