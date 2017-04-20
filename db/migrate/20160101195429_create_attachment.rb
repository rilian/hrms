class CreateAttachment < ActiveRecord::Migration[4.2]
  def change
    create_table :attachments do |t|
      t.references :person, index: true, null: false
      t.string :name, null: false
      t.text :description
      t.timestamps null: false
    end
  end
end
