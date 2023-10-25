class AddNotesToTask < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :notes, :text
  end
end
