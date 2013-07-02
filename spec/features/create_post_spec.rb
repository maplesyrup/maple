require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'Create a Post' do
  scenario 'when logged in' do
    user = FactoryGirl.create(:user)
    company = FactoryGirl.create(:company)
    login_as user, :scope => :user
    visit '/'
    click_link 'Submit Photo'

    within("form#new-post") do
        fill_in 'post-title', :with => 'Test Title'
        fill_in 'post-content', :with => 'Test Content'
        select company.name, :from => 'company'
        attach_file 'post-image', 'spec/images/rails.png'
        click_link 'post-submit'
    end
    
    page.should have_content company.name
  end
end
