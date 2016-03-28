class EventsController < ApplicationController
  def index
    @q = Event.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @events = @q.result

    @events = @events.offset(params.dig(:page, :offset)) if params.dig(:page, :offset).present?
    @events = @events.limit((params.dig(:page, :limit) || ENV['ITEMS_PER_PAGE']).to_i)

    @events = @events.includes(:user)

    respond_to do |f|
      f.partial { render partial: 'table' }
      f.html
    end
  end
end
