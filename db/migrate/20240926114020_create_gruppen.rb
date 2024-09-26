class CreateGruppen < ActiveRecord::Migration[7.2]
  def change
    create_table :gruppens do |t|
      t.string :name
      t.text :beschreibung

      t.timestamps
    end
  end
end
