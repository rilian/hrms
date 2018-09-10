class CopyEmailToPersonalEmailToPerson < ActiveRecord::Migration[5.2]
  def change
    Person.not_deleted.find_each(batch_size: 100) do |person|
      person.update(personal_email: person.email)
    end
  end
end
