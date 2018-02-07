class DefaultStatus < ActiveRecord::Migration[4.2]
  def change
    change_column :people, :status, :string, default: 'n/a', null: false

    Person.where(status: '').update_all(status: 'n/a')
  end
end
