class AddStatusToTodos < ActiveRecord::Migration[7.2]
  def change
    add_column :todos, :status, :string
  end
end
