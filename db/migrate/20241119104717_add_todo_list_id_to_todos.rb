class AddTodoListIdToTodos < ActiveRecord::Migration[7.2]
  def change
    add_column :todos, :todo_list_id, :integer
  end
end
