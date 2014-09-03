require 'features/features_spec_helper'

feature 'Remove image from task' do
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
  
  scenario 'User removes image from task', :js => true do
    page.find('#mini-image').click
    page.find('#remove-image').click
    wait_for_ajax
    expect(page).not_to have_selector '#mini-image'
    expect(page).to have_selector '#icon-image'
  end
end
