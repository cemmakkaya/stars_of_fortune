class RemoveNullConstraintFromUserEmail < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :email, true
  end
end