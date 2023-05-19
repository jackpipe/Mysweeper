FactoryBot.define do
  factory :board do
    name   { Faker::Name.name }
    sequence :email do |n|
      Faker::Internet.email(name: "#{name}#{n}")
    end
    width  { Faker::Number.between(from: 2, to: 100) }
    height { Faker::Number.between(from: 2, to: 100) }
    mines  { Faker::Number.between(from: 2, to: (width-1) * (height-1)) }
  end
end
