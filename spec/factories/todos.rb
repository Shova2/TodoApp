FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.word }
    status { 'pending' } 
    association :todo_list
  end
end


