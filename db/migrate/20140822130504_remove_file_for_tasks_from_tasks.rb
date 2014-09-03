class RemoveFileForTasksFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :file_for_tasks
  end
end
