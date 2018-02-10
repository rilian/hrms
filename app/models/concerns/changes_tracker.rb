module ChangesTracker
  extend ActiveSupport::Concern

  included do
    after_commit :track_changes
  end

  def extract_tracked_changes
    if @_tracked_changes
      tracked_changes = @_tracked_changes.clone
      @_tracked_changes.clear
    end
    
    tracked_changes || {}
  end

  private

  def track_changes
    @_tracked_changes ||= HashWithIndifferentAccess.new
    @_tracked_changes.merge!(previous_changes)
  end
end
