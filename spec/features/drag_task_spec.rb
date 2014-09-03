require 'features/features_spec_helper'

feature 'Drag task' do
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

  scenario 'User drags tasks', :js => true, :retry => 2, :retry_wait => 2 do
    task1_id = '#task' + @task1.id.to_s
    task2_id = '#task' + @task2.id.to_s

    item_element = find(task1_id)     
    new_group_element = find(task2_id)
    item_element.drag_to new_group_element
    
    wait_for_ajax
    
    @task1.reload
    @task2.reload

    @task1.priority.should > @task2.priority
  end
end