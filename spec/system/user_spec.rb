require 'spec_helper'
require 'rails_helper'

RSpec.describe Devise, type: :system do
  let(:email_user) {"kochka_pochka@mail.ru"}
  let(:password_user) {"rijqjr;3rewmnrwea"}
  let(:full_name) {"Ivan Smallgiba"}

  describe 'User sign up' do  
    scenario 'sign up without params' do
      visit new_user_registration_path
      click_button 'Sign up'
      expect(page).to have_content("errors prohibited this user from being saved:\nEmail can't be blank\nPassword can't be blank\n")
    end

    scenario 'sign up without email' do
      visit new_user_registration_path
      fill_in 'Password', with: password_user
      fill_in 'Password confirmation', with: password_user
      click_button 'Sign up'
      expect(page).to have_content("error prohibited this user from being saved:\nEmail can't be blank\n")
    end

    scenario 'sign up without password' do
      visit new_user_registration_path
      fill_in 'Email', with: email_user
      fill_in 'Password confirmation', with: password_user
      click_button 'Sign up'
      expect(page).to have_content("Password confirmation doesn't match Password\n")
    end

    scenario 'sign up, but password confirmation does not match password' do
      visit new_user_registration_path
      fill_in 'Email', with: email_user
      fill_in 'Password', with: password_user
      fill_in 'Password confirmation', with: password_user + '1'
      click_button 'Sign up'
      expect(page).to have_content("Password confirmation doesn't match Password\n")
    end
    
    scenario 'sign up with correct params' do
      visit new_user_registration_path
      fill_in 'Email', with: email_user
      fill_in 'Password', with: password_user
      fill_in 'Password confirmation', with: password_user
      fill_in 'Full name', with: full_name
      click_button 'Sign up'
      expect(page).to have_content("Welcome! You have signed up successfully.\n")
    end
  end
  
  describe 'User Sign In' do
    before :each do
      visit new_user_registration_path
      fill_in 'Email', with: email_user
      fill_in 'Password', with: password_user
      fill_in 'Password confirmation', with: password_user
      fill_in 'Full name', with: full_name
      click_button 'Sign up'
      click_link 'Log out'
    end
  
    scenario 'sign in without params' do
      click_button 'Sign In'
      expect(page).to have_content("Invalid Email or password.\n")
    end

    scenario 'sign in with params' do
      fill_in 'Email', with: email_user
      fill_in 'Password', with: password_user
      click_button 'Sign In'
      expect(page).to have_content("Signed in successfully.\n") 
    end
  end

  describe 'User page navigation' do
    before :each do
      visit new_user_registration_path
      fill_in 'Email', with: email_user
      fill_in 'Password', with: password_user
      fill_in 'Password confirmation', with: password_user
      fill_in 'Full name', with: full_name
      click_button 'Sign up'
    end

    scenario 'Navigation panel' do
      click_link 'Show Profile'
      expect(current_path) == user_profile_path
      click_link 'Chat'
      expect(current_path) == '/rooms'
      click_link 'English'
      expect(current_path) == '/?locale=en'
      click_link 'Русский'
      expect(current_path) == '/?locale=ru'
      click_link 'Maply'
      expect(current_path) == root_path
    end
  end

  describe 'Interaction between of two users' do
    let(:user_one) {User.create(email: "kochka_pochka@mail.ru", password: "rijqjr;3rewmnrwea", full_name: "Zatochka Pochka" )}
    let(:user_two) {User.create(email: "ivan_sobachka_tachka@gmail.ru", password: "Nn;kgwJKBmnvsdBHJfs", full_name: "Ivan Smallgiba" )}

    def user_sign_in(user)
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign In'
    end

    def user_one_request_user_two_accpet(user)
      fill_in 'Search user', with: user.full_name
      click_on 'Search'
      click_on 'Add'
      click_link 'Log out'
      user_sign_in(user_one)
      click_on 'Accept'
    end

    def reload_page
      visit current_path 
    end

    before :each do
      user_sign_in(user_two)
      page.driver.browser.manage.window.resize_to(1920, 1080)
      Capybara.default_max_wait_time = 10
    end

    scenario 'Visit Show Profile' do
      visit user_profile_path
    end

    scenario 'Click on find nearest person' do
      click_button 'Find nearest person to you'
      expect(page).to have_content(user_one.email)
      expect(page).to have_button('Add')
    end

    scenario 'Find and add user_one' do
      fill_in 'Search user', with: user_one.full_name
      click_on 'Search'
      expect(page).to have_button('Add')
    end

    scenario 'Another user add user_one' do
      fill_in 'Search user', with: user_one.full_name
      click_on 'Search'
      click_link 'Log out'
      expect(current_path) == :user_sign_in
      user_sign_in(user_one)
      fill_in 'Search user', with: user_two.full_name
      click_on 'Search'
      click_on 'Add'
      expect(page).to have_button('Cancel')
    end

    scenario 'User_one accept user_two' do
      fill_in 'Search user', with: user_one.full_name
      click_on 'Search'
      click_on 'Add'
      click_link 'Log out'
      expect(current_path) == :user_sign_in
      user_sign_in(user_one)
      expect(page).to have_content(user_one.full_name)
      click_on 'Accept'
    end

    scenario 'User_one accept user_two in Show profile' do
      fill_in 'Search user', with: user_one.full_name
      click_on 'Search'
      click_on 'Add'
      click_link 'Log out'
      expect(current_path) == :user_sign_in
      user_sign_in(user_one)
      visit user_profile_path
      expect(page).to have_content(user_one.full_name)
      click_on 'Accept'
    end

    scenario 'User_one find nearest friend' do
      user_one_request_user_two_accpet(user_one)
      reload_page
      click_button 'Find nearest friend to you'
      expect(page).to have_content(user_one.full_name)
      expect(page).to have_content(user_one.email)
      expect(page).to have_button('Chat')
    end

    scenario 'Chat with another user' do
      user_one_request_user_two_accpet(user_one)
      click_on user_one.full_name
      click_on 'Chat'
    end
  end
end
