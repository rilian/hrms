class AddSkipReviewsToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :skip_reviews, :boolean, default: false
  end
end
