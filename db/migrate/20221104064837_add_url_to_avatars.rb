class AddUrlToAvatars < ActiveRecord::Migration[7.0]
  def change
    add_column :avatars, :avatar_url, :string, :default => nil
  end
end
