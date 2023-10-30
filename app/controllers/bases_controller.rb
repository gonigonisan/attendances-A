class BasesController < ApplicationController
  before_action :admin_user, only: [:new, :create, :edit, :update, :index, :show, :destroy]
  before_action :set_base, only: [:edit, :update, :destroy]

  def index
    @bases = Base.all
  end
  
  def new
    @base = Base.new
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = "拠点登録完了しました。"
      redirect_to bases_path
    else
      flash[:danger] = "拠点情報の作成に失敗しました。" +  @base.errors.full_messages.join("<br>")
      redirect_to :new
    end
  end  
    
  def edit
  end
  
  def update
    @base = Base.find(params[:id])
    if @base.update_attributes(base_params)
      flash[:success] = "#{@base.base_name}の拠点情報を修正しました。"
      redirect_to bases_path
    else
      @base = Base.find(params[:id])
      flash[:danger] = "拠点情報の修正に失敗しました。" + @base.errors.full_messages.join("<br>")
      redirect_to edit
    end
  end  
  
  def show
  end

  def destroy
    @base.destroy
    flash[:success] = "#{@base.base_name}のデータを削除しました。"
    redirect_to bases_path
  end
  
  private
  
    def set_base
      @base = Base.find(params[:id])
    end
  
    def base_params
      params.permit(:base_name, :base_number, :information)
    end    
end

