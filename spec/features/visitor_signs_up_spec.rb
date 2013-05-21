require 'spec_helper'

feature 'Visitor signs up' do
  scenario 'with valid email and password' do
    sign_up_with 'username', 'tester@tester.com', 'password'
    expect(page).to have_content('Logout')
  end
end