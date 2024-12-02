class CreateCollaborators < ActiveRecord::Migration[7.2]
  def change
    create_table :collaborators do |t|
      # t.integer :user_id
      # t.integer :todo_list_id
      t.references :user, null: false, foreign_key: true
      t.references :todo_list, null: false, foreign_key: true


      t.timestamps
    end
    add_index :collaborators, [:user_id, :todo_list_id], unique: true
  end
end
