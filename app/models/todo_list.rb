class TodoList < ApplicationRecord
  belongs_to :user
  has_many :todos, dependent: :destroy
  has_many :collaborators, dependent: :destroy

  validates :title, presence: true
end

