require 'faker'

include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :post do |f|
    f.title { Faker::Lorem.words(num = 3) }
    f.content { Faker::Lorem.words(num = 3) }
    f.company_id 1
    f.user_id 1
    f.image { fixture_file_upload(Rails.root.join('spec', 'images', 'rails.png'), 'image/png') }
  end

end