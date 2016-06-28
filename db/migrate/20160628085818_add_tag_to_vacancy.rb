class AddTagToVacancy < ActiveRecord::Migration
  def change
    add_column :vacancies, :tag, :string
  end
end
