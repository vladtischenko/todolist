require 'features/features_spec_helper'

feature 'Mark all task as complete' do
  background do
    @user = FactoryGirl.create :user
    @todo = FactoryGirl.create :todo, user: @user
    @task1 = FactoryGirl.create :task, todo: @todo
    @task2 = FactoryGirl.create :task, todo: @todo, priority: @task1.priority + 1
    login_as @user, scope: :user
    visit root_path
  end

  after do
    @task2.destroy
    @task1.destroy
    @todo.destroy
    @user.destroy
  end

  scenario 'User marks all task as complete', :js => true do
    check 'All complete'
    expect(page).to have_selector 'a#remove-all'
    expect(page).to have_content '0 tasks is not completed'
    expect(@task1.reload.complete).to eq true
    expect(@task2.reload.complete).to eq true
  end
end