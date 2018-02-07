class AddTagToVacancy < ActiveRecord::Migration[4.2]
  def change
    add_column :vacancies, :tag, :string
  end
end
