class AddCreatedByNameAndUpdatedByNameToVacancy < ActiveRecord::Migration[5.2]
  def change
    add_column :vacancies, :updated_by_name, :string
    add_column :vacancies, :created_by_name, :string

    ActiveRecord::Base.connection.execute('
      UPDATE vacancies SET updated_by_name = (SELECT email FROM users WHERE users.id = vacancies.updated_by_id);
      UPDATE vacancies SET created_by_name = updated_by_name')
  end
end
