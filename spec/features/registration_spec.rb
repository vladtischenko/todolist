require 'features/features_spec_helper'

feature "Registration", js: true do
  scenario "User sign up" do
    visit new_user_registration_path
    within '#new_user' do
      fill_in 'Email', with: 'pupkin@example.com'
      fill_in 'Password', with: 'qweasdzxc'
      fill_in 'Password confirmation', with: 'qweasdzxc'
    end
    click_button 'Sign up'
    expect(page).to have_selector 'input#add-todo'
  end
end