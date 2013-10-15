class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    # Makes the email column in user indexed and forces unique emails.
    # db validation for unique email because the User model can only enforce this at the memory level.
    add_index :users, :email, unique: true
  end
end
