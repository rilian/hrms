class AddStatusToVacancy < ActiveRecord::Migration
  def change
    add_column :vacancies, :status, :string, default: 'open'
  end
end
