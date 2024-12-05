class Collaborator < ApplicationRecord
    belongs_to :todo_list
    belongs_to :user
  
    # Validate that user_id is not equal to the owner of the todo_list
    validate :is_user_a_todo_list_owner
  
    private
  
    def is_user_a_todo_list_owner
      if todo_list.user_id == user_id
        errors.add(:user_id, " user cannot be the owner of the Todo List")
      end
    end
  end
  
