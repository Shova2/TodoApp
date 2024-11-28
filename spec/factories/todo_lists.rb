FactoryBot.define do
  factory :todo_list do
    title { Faker::Lorem.sentence }
    association :user
  end
end



