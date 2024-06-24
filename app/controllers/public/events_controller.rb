class Public::EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = Event.all
    respond_to do |format|
      format.html
      format.json { render 'calendar' }
    end
  end
end
