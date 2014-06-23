require 'features/features_spec_helper'

feature 'Add todo' do
  background do
    @user = FactoryGirl.create :user
    login_as @user, scope: :user
  end
  
  scenario 'User add new todo', js: true do
    visit todos_path
    # expect(page).to have_selector 'input#add-todo'
  end
end