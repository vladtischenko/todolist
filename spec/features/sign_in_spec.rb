require 'features/features_spec_helper'

feature "Sign in" do
  background do
    @user = FactoryGirl.create :user
  end

  after do
    @user.destroy
  end

  scenario "User sign in", :js => true do
    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
    end
    click_button 'Sign in'
    expect(page).to have_selector 'input#add-todo'
  end

  context 'User not registered' do
    background do
      @user.destroy
    end

    scenario 'User tries to sign in but it is fail because he is not registered' do
      visit new_user_session_path
      within '#new_user' do
        fill_in 'Email', with: Faker::Internet.email
        fill_in 'Password', with: Faker::Internet.password(8)
      end
      click_button 'Sign in'
      expect(page).to have_content 'Invalid email or password.'
    end
  end

end
 