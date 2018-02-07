class CreateSearches < ActiveRecord::Migration[4.2]
  def change
    create_table :searches do |t|
      t.string :query
      t.string :path
      t.string :ip

      t.timestamps
    end
  end
end
