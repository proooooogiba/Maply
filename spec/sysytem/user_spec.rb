require 'spec_helper'
require 'rails_helper'

RSpec.describe Devise, type: :system do
  let(:email_user) {"oleg-nsk@mail.ru"}
  let(:password_user) {"ts6GwTyLCzEYNmG"}
  describe 'User sign up' do
    
    scenario 'sign up without params' do
      visit new_user_registration_path
      click_button 'Sign up'
      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
  end

    scenario 'sign up without email' do
      visit new_user_registration_path
      fill_in 'Password', with: password_user
      fill_in 'Password confirmation', with: password_user
      click_button 'Sign up'
      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end

    scenario 'sign up without password' do
      visit new_user_registration_path
      fill_in 'Email', with: email_user
      fill_in 'Password confirmation', with: password_user
      click_button 'Sign up'
      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end

    scenario 'sign up, but password confirmation does not match password' do
      visit new_user_registration_path
      fill_in 'Email', with: email_user
      fill_in 'Password', with: password_user
      fill_in 'Password confirmation', with: password_user + '1'
      click_button 'Sign up'
      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
    
    scenario 'sign up with correct params and sign in' do
      visit new_user_registration_path
      fill_in 'Email', with: email_user
      fill_in 'Password', with: password_user
      fill_in 'Password confirmation', with: password_user
      fill_in 'Full name', with: 'Oleg Pogiba'
      click_button 'Sign up'
      fill_in 'Email', with: email_user
      fill_in 'Password', with: password_user
      click_button("Create")

      expect(page).to have_content(" Signed in successfully.\n")
    end

  #   scenario 'sign up with correct params' do
  #     visit new_user_registration_path
  #     fill_in 'Email', with: email_user
  #     fill_in 'Password', with: password_user
  #     fill_in 'Password confirmation', with: password_user
  #     click_button 'Sign up'
      
  #     ctoken = Devise.mailer.deliveries.last.body.match(/confirmation_token=\w*/)
  #     visit "/users/confirmation?#{ctoken}"
  #     expect(page).to have_content("Your email address has been successfully confirmed.\n")
  #   end

  describe 'User sign in' do
    before :each do
      visit new_user_registration_path
      fill_in 'Email', with: email_user
      fill_in 'Password', with: password_user
      fill_in 'Password confirmation', with: password_user
      click_button 'Sign up'
      visit new_user_session_path
    end
  end

    scenario 'sign in without params' do
      click_button 'Log in'
      expect(page).to have_content("Invalid Email or password.\n")
    end

    scenario 'sign in with params' do
      fill_in 'Email', with: email_user
      fill_in 'Password', with: password_user
      click_button 'Log in'
      expect(page).to have_content("Signed in successfully.\n")
    
    end

  #   scenario 'sign in with params and make calculations' do
  #     fill_in 'Email', with: email_user
  #     fill_in 'Password', with: password_user
  #     click_button 'Log in'
  #     fill_in :calucaltion_field, with: 100
  #     click_button 'Calculate'
  #     expect(page).to have_current_path('/calc/view?num=100&commit=Посчитать')
  #   end
  # end

  # describe 'User try to make calculations' do
  #   scenario 'sign in with params and make calculations' do
  #     visit '/calc/view?num=100&commit=Посчитать'
  #     expect(page).to have_current_path(new_user_session_path)
  #   end
  # end
end