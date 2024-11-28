require 'rails_helper'

RSpec.describe TodoList, type: :model do
  #validation 
  it { should validate_presence_of(:title) }
  #association
  it { should belong_to(:user) }
  it { should have_many(:todos) }
end

