require 'features/features_spec_helper'

feature 'Change todo title' do
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

  scenario 'User changes todo title', :js => true do
    page.find('#title-todo').double_click
    fill_in 'Edit todo', with: 'new todo'
    find('input#edit-todo').native.send_keys(:enter)
    wait_for_ajax
    expect(page).to have_content 'new todo'
    expect(@todo.reload.title).to eq 'new todo'
  end
end