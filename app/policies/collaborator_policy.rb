class CollaboratorPolicy < ApplicationPolicy
    # TodoList owner can create any collaborator
    def create?
      user_is_owner?
    end
    
    # TodoList owner can delete any collaborator
    def destroy?
      user_is_owner?
    end
  
    private
  
    # Check if the user is the owner of the TodoList associated with the collaborator
    def user_is_owner?
      record.todo_list.user_id == user.id
    end
  end
  