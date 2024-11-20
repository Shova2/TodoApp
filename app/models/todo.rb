class Todo < ApplicationRecord
  belongs_to :todo_list

  validates :title, presence: true
  validates  :status, inclusion: {
    in: %w[pending in_progress completed archived],
    message: "%{value}  is invalid"
  }
end
