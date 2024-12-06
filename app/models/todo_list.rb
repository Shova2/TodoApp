class TodoList < ApplicationRecord
  belongs_to :user
  has_many :todos, dependent: :destroy
  has_many :collaborators, dependent: :destroy
  has_many :users, through: :collaborators

  validates :title, presence: true
  # Check if the given user is the owner of the TodoList
  def owned_by?(user)
    self.user_id == user.id
  end

  # Check if the given user is a collaborator of the TodoList
  def collaborated_by?(user)
    collaborators.exists?(user_id: user.id)
  end
end

