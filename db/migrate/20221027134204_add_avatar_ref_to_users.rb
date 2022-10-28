class AddAvatarRefToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :avatar, foreign_key: true
  end
end
