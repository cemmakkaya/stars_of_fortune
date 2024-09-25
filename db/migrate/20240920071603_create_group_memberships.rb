class CreateGroupMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :group_memberships do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end