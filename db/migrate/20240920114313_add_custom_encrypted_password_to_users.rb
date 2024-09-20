class AddCustomEncryptedPasswordToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :custom_encrypted_password, :string
  end
end