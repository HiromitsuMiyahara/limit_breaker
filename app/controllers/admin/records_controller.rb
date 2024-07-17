class Admin::RecordsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @user = User.find(params[:id])
    @records = Record.where(user_id: @user.id)
  end

  def show
    @record = Record.find(params[:id])
  end

  def edit
    @record = Record.find(params[:id])
  end

  def update
    record = Record.find(params[:id])
    if record.update(record_params)
      flash[:notice] = "記録を編集しました。"
      redirect_to admin_record_path(record.id)
    else
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    record = Record.find(params[:id])
    if record.destroy
      flash[:notice] = "記録を削除しました。"
      redirect_to admin_user_path(user.id)
    else
      render :index
    end
  end

  private
    def record_params
      params.require(:record).permit(:date, :part, :place, :exercise, :weight, :rep, :set)
    end
end
