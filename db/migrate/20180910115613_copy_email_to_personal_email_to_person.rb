class CopyEmailToPersonalEmailToPerson < ActiveRecord::Migration[5.2]
  def change
    ActiveRecord::Base.connection.execute('
      UPDATE people SET personal_email = email
    ')
  end
end
