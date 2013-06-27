require 'spec_helper'

feature 'Visitor signs up' do
  scenario 'with valid email and password' do
    sign_up_with 'username', 'tester@tester.com', 'password'
    expect(page).to have_content('Logout')
  end

  scenario 'with invalid email and valid password' do
    sign_up_with 'username', 'test', 'password'
    expect(page).to have_content('Email is invalid')
  end

  scenario 'with valid email and invalid password' do
    sign_up_with 'username', 'tester@tester.com', 'hi'
    expect(page).to have_content('Password is too short')
  end

  scenario 'with invalid email and invalid password' do
    sign_up_with 'username', 'tester', 'hi'
    expect(page).to have_content('Email is invalid')
    expect(page).to have_content('Password is too short')
  end

  scenario 'with existing email' do
    user = FactoryGirl.create(:user)
    sign_up_with 'username', user.email, user.password
    expect(page).to have_content('Email has already been taken')
  end
end