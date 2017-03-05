FactoryGirl.define do
  factory :task do
    title { Faker::Lorem.word }
    board_id nil
    completed_at nil
  end
end