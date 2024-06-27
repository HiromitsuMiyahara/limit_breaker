class Public::RecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :recorded_user, only: [:edit, :update]

  def new
    @record = Record.new
    #current_user.idの全ての記録を返す
  end

  def index
    @records = Record.where(user_id: current_user.id).order(start_time: "desc")
  end

  def show
    @record = Record.find(params[:id])
  end

  def create
    @records = Record.where(user_id: current_user.id).order(start_time: "desc")
    @record = Record.new(record_params)
    @record.user_id = current_user.id # ログインしているユーザーのIDを設定
    if @record.save
      flash[:notice] = 'トレーニング記録が保存されました。'
      redirect_to new_record_path
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
      flash.now[:notice] = '編集に失敗しました。'
      render :edit
    end
  end

  def destroy
    @record = Record.find(params[:id])
    if @record.destroy
      flash[:notice] = '記録を削除しました。'
      redirect_to new_record_path
    else
      flash.now[:notice] = '削除に失敗しました。'
      render :new
    end
  end

  private

  def record_params
    params.require(:record).permit(:start_time, :part, :place, :exercise, :weight, :rep, :set)
  end

  def recorded_user
    @record = Record.find(params[:id])
    unless @record.user == current_user
      redirect_to records_path
    end
  end
end
