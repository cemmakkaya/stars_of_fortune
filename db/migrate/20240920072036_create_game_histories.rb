class CreateGameHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :game_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.integer :amount
      t.string :action

      t.timestamps
    end
  end
end
