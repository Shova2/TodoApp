FactoryBot.define do
    factory :collaborator do
      # Associate a user and a todo_list
      user
      todo_list
  
      # Trait to ensure the collaborator is not the owner
      trait :non_owner do
        association :user, factory: :user # Ensure it's a different user from the todo_list owner
        todo_list { create(:todo_list) } # Create a new todo_list to prevent user from being the owner
      end
    end
  end
  