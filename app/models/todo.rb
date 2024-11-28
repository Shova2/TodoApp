class Todo < ApplicationRecord
  belongs_to :todo_list
  enum status: { pending: 'pending', in_progress: 'in_progress', completed: 'completed', archived: 'archived' }
  validates :status, inclusion: { in: statuses.keys }
  validates :title, presence: true
  after_initialize :set_default_status, if: :new_record?

  private
  def set_default_status
    self.status ||= 'pending'
  end
end



