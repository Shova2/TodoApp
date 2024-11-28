require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:todo_lists) }

  # Validation tests for email
  it "is invalid without an email" do
    user = FactoryBot.build(:user, email: nil) 
    #checking validation 
    expect(user.valid?).to be_falsey
    expect(user.errors[:email]).to include("can't be blank")
  end
  it "is valid with a valid email" do
    user = FactoryBot.create(:user)  
    expect(user.valid?).to be_truthy
  end
end
