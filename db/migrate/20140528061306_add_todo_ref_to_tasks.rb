class AddTodoRefToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :todo, index: true
  end
end
