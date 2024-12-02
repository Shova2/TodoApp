class Collaborator < ApplicationRecord
    belongs_to :todo_list
    belongs_to :user
  
    # Validate that user_id is not equal to the owner of the todo_list
    validate :user_cannot_be_todo_list_owner
  
    private
  
    def user_cannot_be_todo_list_owner
      if todo_list.user_id == user_id
        errors.add(:user_id, "cannot be the owner of the Todo List")
      end
    end
  end
  
