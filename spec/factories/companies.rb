require 'faker'

FactoryGirl.define do
  factory :company do |f|
    f.name { Faker::Lorem.word }
    f.email { Faker::Internet.email }
    f.password "password"
  end
end