class AddFieldsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :text, :string
    add_column :tasks, :priority, :integer
    add_column :tasks, :complete, :boolean
  end
end
