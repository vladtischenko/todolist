require 'features/features_spec_helper'

feature 'Add todo' do
  background do
    @user = FactoryGirl.create :user
    login_as @user, scope: :user
  end
  
  after do
    @user.destroy
  end

  scenario 'User adds new todo', :js => true do
    visit root_path
    fill_in 'Add todo', with: Faker::Lorem.sentence
    find('#add-todo').native.send_keys(:enter)
    expect(page).to have_selector 'input#add-task'
    expect(@user.todos.count).to eq 1
  end
end