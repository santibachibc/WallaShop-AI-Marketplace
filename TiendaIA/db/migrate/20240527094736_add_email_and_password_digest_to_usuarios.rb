class AddEmailAndPasswordDigestToUsuarios < ActiveRecord::Migration[7.1]
  def change
    add_column :usuarios, :email, :string
    add_index :usuarios, :email, unique: true
    add_column :usuarios, :password_digest, :string
  end
end
