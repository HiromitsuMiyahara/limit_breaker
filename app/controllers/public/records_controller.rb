class Public::RecordsController < ApplicationController
  before_action :recorded_user, only: [:edit, :update]

  def new
    @record = Record.new
  end

  def index
    #current_user.idの全ての記録を返す
    @records = Record.where(user_id: current_user.id)
  end

  def show
    @record = Record.find(params[:id])
  end

  def create
    @record = Record.new(record_params)
    @record.user_id = current_user.id # ログインしているユーザーのIDを設定
    if @record.save
      redirect_to records_path, notice: 'トレーニング記録が保存されました。'
    else
      render :new
    end
  end

  def edit
    @record = Record.find(params[:id])
  end

  def update
    @record = Record.find(params[:id])
    if @record.update(record_params)
      flash[:notice] = '記録を編集しました。'
      redirect_to record_path(@record.id)
    else
      render :edit
    end
  end

  def destroy
    @record = Record.find(params[:id])
    if @record.destroy
      flash[:notice] = '記録を削除しました。'
      redirect_to records_path
    else
      render :index
    end
  end

  private

  def record_params
    params.require(:record).permit(:date, :part, :place, :exercise, :weight, :rep, :set)
  end

  def recorded_user
    @record = Record.find(params[:id])
    unless @record.user == current_user
      redirect_to records_path
    end
  end
end
