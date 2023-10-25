class ChangePriorityColumnTypeInTasks < ActiveRecord::Migration[7.1]
  def change
    change_column :tasks, :priority, :string
  end
end
