class CollaboratorPolicy < ApplicationPolicy
    # Check if the user is a collaborator
    def user_is_owner?
        record.todo_list.owned_by?(user)
    end
    # Onwer can see all the collaborator
    def index?
        user_is_owner?
    end
    # TodoList owner can create any collaborator
    def create?
      user_is_owner?
    end
    
    # TodoList owner can delete any collaborator
    def destroy?
      user_is_owner?
    end
end
  