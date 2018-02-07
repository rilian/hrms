module Concerns::Event
  extend ActiveSupport::Concern

  def log_event(entity:, action:)
    changes = entity.respond_to?(:extract_tracked_changes) ? entity.extract_tracked_changes : entity.previous_changes

    ::Event.log(
      entity: entity,
      action: action,
      user: current_user,
      params: changes
    )
  end
end
