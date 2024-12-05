class TodoListPolicy < ApplicationPolicy
  # Check if the user is an owner
  def user_is_owner?
    record.owned_by?(user)
  end

  # Check if the user is a collaborator
  def user_is_collaborator?
    record.collaborated_by?(user)
  end

  # User can view the TodoList if they own it or are a collaborator
  def show?
    user_is_owner? || user_is_collaborator?
  end
  
  # User can update the TodoList if they are the owner
  def update?
    user_is_owner?
  end

  # User can delete the TodoList if they are the owner
  def destroy?
    user_is_owner?
  end

  # User can create TodoLists for themselves
  def create?
    true
  end

  # User can see the list of TodoLists if they own it or are a collaborator
  def index?
    true
  end

  class Scope < Scope
    def resolve
      scope
        .left_outer_joins(:collaborators)
        .where("todo_lists.user_id = :user_id OR collaborators.user_id = :user_id", user_id: user.id)
    end
  end 
end
