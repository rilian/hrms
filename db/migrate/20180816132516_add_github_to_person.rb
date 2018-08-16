class AddGithubToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :github, :string
  end
end
