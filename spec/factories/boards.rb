FactoryGirl.define do
  factory :board do
    title { Faker::Lorem.word }
  end
end