class AddSelectedCardToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :selected_card, :integer
  end
end