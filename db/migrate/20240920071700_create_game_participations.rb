class CreateGameParticipations < ActiveRecord::Migration[7.2]
  def change
    create_table :game_participations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.integer :selected_card
      t.integer :bet_amount

      t.timestamps
    end
  end
end
