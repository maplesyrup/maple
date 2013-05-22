module Features
  module SessionHelpers
    def sign_up_with(username, email, password)
      visit('/users/sign_up')
      fill_in('Enter a username', with: username)
      fill_in('Enter your email address', with: email)
      fill_in('Enter your password', with: password)
      fill_in('Confirm your password', with: password)
      click_on('Sign up')
    end

    def sign_in
      user = FactoryGirl.create(:user)
      visit('/users/sign_in')
      fill_in('Enter your email address', with: user.email)
      fill_in('Enter your password', with: user.password)
      click_on("Login")
    end
  end
end