class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.references :group, null: false, foreign_key: true
      t.string :status
      t.integer :winning_card

      t.timestamps
    end
  end
end
