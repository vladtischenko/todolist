class AddUserRefToTodos < ActiveRecord::Migration
  def change
    add_reference :todos, :user, index: true
  end
end
