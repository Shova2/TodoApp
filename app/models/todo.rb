class Todo < ApplicationRecord
  belongs_to :todo_list
  # enum status: { pending: 'pending', in_progress: 'in_progress', completed: 'completed', archived: 'archived' }
  enum :status, { pending: 0, in_progress: 1, completed: 2, archived: 3 } # Corrected
  validates :status, inclusion: { in: statuses.keys }
  validates :title, presence: true
  # after_initialize :set_default_status, if: :new_record?

  # private
  # def set_default_status
  #   self.status ||= 'pending'
  # end
end



