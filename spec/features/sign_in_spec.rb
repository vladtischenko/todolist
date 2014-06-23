require 'features/features_spec_helper'

feature "Sign in" do
  background do
    @user = FactoryGirl.create :user
    login_as @user
  end

  scenario "User sign in", js: true do
    visit new_user_session_path
    # within '#new_user' do
      # fill_in 'Email', with: @user.email
      # fill_in 'Password', with: @user.password
    # end
    # click_button 'Sign in'
    # expect(page).to have_selector 'input#add-todo'
  end
end
