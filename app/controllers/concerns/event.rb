module Concerns::Event
  extend ActiveSupport::Concern

  def log_event(entity:, action:)
    ::Event.log(
      entity: entity,
      action: action,
      user: current_user,
      params: entity.previous_changes
    )
  end
end
