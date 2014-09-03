require 'features/features_spec_helper'

feature 'Show file area' do
  background do
    @user = FactoryGirl.create :user
    @todo = FactoryGirl.create :todo, user: @user
    @task = FactoryGirl.create :task, todo: @todo, file_for_task: nil
    login_as @user, scope: :user
    visit root_path
  end

  after do
    @task.destroy
    @todo.destroy
    @user.destroy
  end

  scenario 'User click on icon and see file area', :js => true do
    page.find('#icon-image').click
    expect(page).to have_selector '#file-area'
    expect(page).to have_selector 'input#browse'
  end

end
