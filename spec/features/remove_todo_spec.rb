require 'features/features_spec_helper'

feature 'Remove todo' do
  background do
    @user = FactoryGirl.create :user
    @todo = FactoryGirl.create :todo, user: @user
    login_as @user, scope: :user
    visit root_path
  end

  after do
    @todo.destroy
    @user.destroy
  end

  scenario 'User remove todo', :js => true do
    page.find('#remove-todo').click
    wait_for_ajax
    expect(page).not_to have_selector 'input#add-task'
    expect(@user.todos.count).to eq 0
  end
end