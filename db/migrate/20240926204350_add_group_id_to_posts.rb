class AddGroupIdToPosts < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:posts, :group_id)
      add_reference :posts, :group, null: false, foreign_key: true
    end
  end
end