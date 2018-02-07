module Concerns::Event
  extend ActiveSupport::Concern

  def log_event(entity:, action:)
    ::Event.log(
      entity: entity,
      action: action,
      user: current_user,
      params: entity.extract_tracked_changes
    )
  end
end
