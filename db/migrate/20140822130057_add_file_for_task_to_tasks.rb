class AddFileForTaskToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :file_for_tasks, :string
  end
end
