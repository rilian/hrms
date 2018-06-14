class AddLastPerformanceReviewAt < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :last_performance_review_at, :date
  end
end
