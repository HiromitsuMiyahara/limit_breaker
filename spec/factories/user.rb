FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    encrypted_password { Faker::Lorem.characters(number: 6) }
  end
end
