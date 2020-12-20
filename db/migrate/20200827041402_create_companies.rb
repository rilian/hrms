class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :reply_to
      t.string :from
      t.integer :status_id, index: true

      t.timestamps
    end
  end
end
