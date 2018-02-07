class AddStatusToVacancy < ActiveRecord::Migration[4.2]
  def change
    add_column :vacancies, :status, :string, default: 'open'
  end
end
