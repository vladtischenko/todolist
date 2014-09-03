require 'features/features_spec_helper'

feature 'Change task text' do
  background do
    @user = FactoryGirl.create :user
    @todo = FactoryGirl.create :todo, user: @user
    @task = FactoryGirl.create :task, todo: @todo
    login_as @user, scope: :user
    visit root_path
  end

  after do
    @task.destroy
    @todo.destroy
    @user.destroy
  end

  scenario 'User changes task text', :js => true do
    page.find('#task-text').double_click
    fill_in 'Edit task', with: 'new task'
    find('#edit-task').native.send_keys(:enter)
    wait_for_ajax
    expect(page).to have_content 'new task'
    expect(@task.reload.text).to eq 'new task'
  end
end