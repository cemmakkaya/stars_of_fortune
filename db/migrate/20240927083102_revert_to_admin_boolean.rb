class RevertToAdminBoolean < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :admin, :boolean, default: false

    # Setzen Sie das admin-Feld basierend auf der Rolle
    User.reset_column_information
    User.where(role: 'admin').update_all(admin: true)

    remove_column :users, :role
  end

  def down
    add_column :users, :role, :string, default: 'user'

    # Setzen Sie die Rolle basierend auf dem admin-Feld
    User.reset_column_information
    User.where(admin: true).update_all(role: 'admin')
    User.where(admin: false).update_all(role: 'user')

    remove_column :users, :admin
  end
end