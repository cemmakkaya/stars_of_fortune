class UpdateDefaultCBucksForUsers < ActiveRecord::Migration[6.1]
  def up
    # Füge die Spalte hinzu, falls sie noch nicht existiert
    unless column_exists?(:users, :c_bucks)
      add_column :users, :c_bucks, :integer, default: 500
    end

    # Setze den Standardwert für bestehende Einträge
    User.where(c_bucks: nil).update_all(c_bucks: 500)

    # Ändere den Standardwert für zukünftige Einträge
    change_column_default :users, :c_bucks, 500
  end

  def down
    change_column_default :users, :c_bucks, nil
  end
end