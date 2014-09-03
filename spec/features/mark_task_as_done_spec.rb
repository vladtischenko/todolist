require 'features/features_spec_helper'

feature 'Mark task as done' do
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

  scenario 'User marks task as done', :js => true do
    page.find('#complete-task').click
    wait_for_ajax
    expect(page).to have_selector 'strike'
    expect(@task.reload.complete).to eq true
  end
end