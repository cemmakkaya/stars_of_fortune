class CreateGameParticipations < ActiveRecord::Migration[7.0]
  def change
    create_table :game_participations do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :game, null: false, foreign_key: true
      t.integer :selected_card
      t.integer :bet_amount

      t.timestamps
    end
  end
end