class RenameFileFiledInTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :file
    add_column :tasks, :file_for_task, :string
  end
end
