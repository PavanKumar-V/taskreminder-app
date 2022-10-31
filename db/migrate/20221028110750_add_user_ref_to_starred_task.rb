class AddUserRefToStarredTask < ActiveRecord::Migration[7.0]
  def change
    add_reference :starred_tasks, :user, null: false, foreign_key: true
  end
end
