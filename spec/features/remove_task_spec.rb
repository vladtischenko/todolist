require 'features/features_spec_helper'

feature 'Remove task' do
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

  scenario 'User removes task', :js => true do
    page.find('#remove-task').click
    wait_for_ajax
    expect(page).not_to have_selector 'div#task'
    expect(@user.todos.first.tasks.count).to eq 0
  end
end