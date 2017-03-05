FactoryGirl.define do
  factory :task do
    title { Faker::Lorem.word }
    board
    completed_at nil
  end
end