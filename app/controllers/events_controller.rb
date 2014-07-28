class EventsController < ApplicationController
  before_action :authenticate, except: :show
  before_action :set_event, only: [ :edit, :update, :destroy ]

  def index
    @events = Event.where('start_time > ?', Time.zone.now).order(:start_time)
  end

  def show
    @event = Event.find params[:id]
    @ticket = current_user && current_user.tickets.find_by(event_id: params[:id])
    @tickets = @event.tickets.includes(:user).order(:created_at)
  end

  def new
    @event = current_user.created_events.build
  end

  def create
    @event = current_user.created_events.build event_params
    if @event.save
      redirect_to @event, notice: '作成しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @event.update event_params
      redirect_to @event, notice: '更新しました'
    else
      render :edit
    end
  end

  def destroy
    @event.destroy!
    redirect_to root_path, notice: '削除しました'
  end

  private
  def set_event
    @event = current_user.created_events.find params[:id]
  end

  def event_params
    params.require(:event).permit(
      :name, :place, :event_image, :event_image_cache,
      :remove_event_image, :content, :start_time, :end_time
    )
  end
end
