class CreateStarredTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :starred_tasks do |t|
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
