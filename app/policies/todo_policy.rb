class TodoPolicy < ApplicationPolicy
  def user_is_owner?
    record.todo_list.owned_by?(user) 
  end

  def user_is_collaborator?
    record.todo_list.collaborated_by?(user)
  end

  def create?
    user_is_owner? ||user_is_collaborator?
  end

  def update?
    user_is_owner? || user_is_collaborator?
  end

  def show?
    user_is_owner? || user_is_collaborator?
  end

  def destroy?
    user_is_owner?
  end
end

