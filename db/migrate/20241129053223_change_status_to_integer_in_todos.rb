class ChangeStatusToIntegerInTodos < ActiveRecord::Migration[7.2]
  def up
    # Add the new integer column
    add_column :todos, :status_new, :integer, default: 0, null: false

    # Migrate the existing string data to integer
    Todo.reset_column_information
    Todo.find_each do |todo|
      todo.update_column(:status_new, Todo.statuses[todo.status]) if todo.status.present?
    end

    # Remove the old string column
    remove_column :todos, :status

    # Rename the new column to 'status'
    rename_column :todos, :status_new, :status
  end

  def down
    # Add back the old string column
    add_column :todos, :status_old, :string

    # Migrate the integer data back to strings
    Todo.reset_column_information
    Todo.find_each do |todo|
      todo.update_column(:status_old, Todo.statuses.key(todo.status)) if todo.status.present?
    end

    # Remove the integer column
    remove_column :todos, :status

    # Rename the old column back to 'status'
    rename_column :todos, :status_old, :status
  end
end
