class AddNextPerformanceReviewToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :next_performance_review_at, :date
  end
end
