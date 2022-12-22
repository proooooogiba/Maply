# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.describe Devise, type: :system do
  let(:email_user) { 'kochka_pochka@mail.ru' }
  let(:password_user) { 'rijqjr;3rewmnrwea' }
  let(:full_name) { 'Ivan Smallgiba' }

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
      expect(page).to have_content("4 errors prohibited this user from being saved:\nEmail can't be blank\n")
    end

    scenario 'sign up without password' do
      visit new_user_registration_path
      fill_in 'email-input', with: email_user, wait: 10
      fill_in 'Password confirmation', with: password_user
      click_button 'Sign up'
      expect(page).to have_content("Password confirmation doesn't match Password\n")
    end

    scenario 'sign up, but password confirmation does not match password' do
      visit new_user_registration_path
      fill_in 'email-input', with: email_user, wait: 10
      fill_in 'Password', with: password_user
      fill_in 'Password confirmation', with: "#{password_user}1"
      click_button 'Sign up'
      expect(page).to have_content("Password confirmation doesn't match Password\n")
    end

    scenario 'sign up with correct params' do
      visit new_user_registration_path
      fill_in 'email-input', with: email_user, wait: 10
      fill_in 'password-input', with: password_user, wait: 10
      fill_in 'Password confirmation', with: password_user
      fill_in 'Full name', with: full_name
      click_button 'Sign up'
      expect(page).to have_content("Welcome! You have signed up successfully.\n")
    end
  end

  describe 'User Sign In' do
    before :each do
      visit new_user_registration_path
      fill_in 'email-input', with: email_user, wait: 10
      fill_in 'password-input', with: password_user, wait: 10
      fill_in 'Password confirmation', with: password_user
      fill_in 'Full name', with: full_name
      click_button 'Sign up'
      find('#log_out').click
    end

    scenario 'sign in without params' do
      click_button 'Sign In'
      expect(page).to have_content("Invalid Email or password.\n")
    end

    scenario 'sign in with params' do
      fill_in 'email-input', with: email_user, wait: 10
      fill_in 'password-input', with: password_user, wait: 10
      click_button 'Sign In'
      expect(page).to have_content("Signed in successfully.\n")
    end
  end

  describe 'User page navigation' do
    before :each do
      visit new_user_registration_path
      fill_in 'email-input', with: email_user, wait: 10
      fill_in 'password-input', with: password_user, wait: 10
      fill_in 'Password confirmation', with: password_user
      fill_in 'Full name', with: full_name
      click_button 'Sign up'
    end

    scenario 'Navigation panel' do
      find('#show_profile').click
      expect(current_path) == user_profile_path
      find('#chat').click
      expect(current_path) == '/rooms'
      find('#root').click
      expect(current_path) == root_path
    end
  end

  describe 'Interaction between of two users' do
    let(:user_one) do
      User.create(email: 'kochka_pochka@mail.ru', password: 'rijqjr;3rewmnrwea', full_name: 'Zatochka Pochka')
    end
    let(:user_two) do
      User.create(email: 'ivan_sobachka_tachka@gmail.ru', password: 'Nn;kgwJKBmnvsdBHJfs', full_name: 'Ivan Smallgiba')
    end
    let(:message) { 'Hello!' }

    def user_sign_in(user)
      sleep(5)
      visit new_user_session_path
      fill_in 'email-input', with: user.email, wait: 10
      fill_in 'password-input', with: user.password, wait: 10
      click_button 'Sign In'
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
      expect(page).to have_content(user_two.full_name)
      expect(page).to have_content(user_two.email)
      expect(page).to have_content("You haven't got any friends request")
    end

    scenario 'Click on find nearest person' do
      sleep(5)
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
      find('#log_out').click
      expect(current_path) == :user_sign_in
      user_sign_in(user_one)
      expect(page).to have_content(user_one.full_name)
      click_on 'Accept'
    end

    scenario 'User_one accept user_two in Show profile' do
      fill_in 'Search user', with: user_one.full_name, wait: 10
      click_on 'Search'
      click_on 'Add'
      sleep(5)
      find('#log_out').click
      expect(current_path) == :user_sign_in
      user_sign_in(user_one)
      sleep(5)
      find('#show_profile').click
      expect(page).to have_content(user_one.full_name)
      click_button 'Accept'
      expect(page).to have_content(user_one.full_name)
    end

    scenario 'User_one find nearest friend' do
      fill_in 'Search user', with: user_one.full_name
      click_on 'Search'
      click_on 'Add'
      find('#log_out').click
      expect(current_path) == :user_sign_in
      user_sign_in(user_one)
      expect(page).to have_content(user_one.full_name)
      click_on 'Accept'
      reload_page
      sleep(5)
      click_button 'Find nearest friend to you'
      expect(page).to have_content(user_one.full_name)
      expect(page).to have_content(user_one.email)
      expect(page).to have_link('Chat')
      find('#chat_btn').click
      expect(current_path) == '/rooms'
      sleep(5)
      find('#log_out').click
    end

    scenario 'User_one send message to user_two' do
      fill_in 'Search user', with: user_one.full_name
      click_on 'Search'
      click_on 'Add'
      find('#log_out').click
      expect(current_path) == :user_sign_in
      user_sign_in(user_one)
      expect(page).to have_content(user_one.full_name)
      click_on 'Accept'
      reload_page
      sleep(5)
      find('#chat').click
      find("#user_#{user_two.id}").click
      fill_in 'chat-text', with: message
      click_on 'Send'
      expect(page).to have_content('less than a minute ago')
      expect(page).to have_content(message)
      sleep(5)
      find('#log_out').click
      user_sign_in(user_two)
      sleep(5)
      find('#chat').click
      find("#user_#{user_one.id}").click
      expect(page).to have_content(message)
    end

    scenario 'User_one add friend from user_two profile' do
      fill_in 'Search user', with: user_one.full_name
      click_on 'Search'
      click_on 'Add'
      find('#log_out').click
      expect(current_path) == :user_sign_in
      user_sign_in(user_one)
      expect(page).to have_content(user_one.full_name)
      click_on 'Accept'
      reload_page
      sleep(5)
      user_three = User.create(email: 'boba_biba@gmail.ru', password: 'Nn;kgwJKBmnvsdBHJfs', full_name: 'Egor Biggiba')
      sleep(5)
      find('#log_out').click
      user_sign_in(user_three)
      fill_in 'Search user', with: user_two.full_name
      click_on 'Search'
      click_on 'Add'
      sleep(5)
      find('#log_out').click
      user_sign_in(user_two)
      click_on 'Accept'
      sleep(10)
      find('#log_out').click
      user_sign_in(user_three)
      sleep(5)
      find('#show_profile').click
      expect(page).to have_content(user_two.full_name)
      find("#user_#{user_two.id}").click
      expect(page).to have_content(user_one.full_name)
      find("#user_#{user_one.id}").click
      expect(page).to have_button('Add')
      sleep(20)
    end
  end
end
