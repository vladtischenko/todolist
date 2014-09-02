require 'features/features_spec_helper'

feature 'Drag todo' do
  background do
    @user = FactoryGirl.create :user
    @todo1 = Todo.create(title: 'new todo', priority: 1, user: @user)
    @todo2 = Todo.create(title: 'new todo2', priority: 2, user: @user)
    login_as @user, scope: :user
    visit root_path
  end
  
  after do
    @todo2.destroy
    @todo1.destroy
    @user.destroy
  end

  scenario 'User drag todos', :js => true do
    todo1_id = '#todo' + @todo1.id.to_s
    todo2_id = '#todo' + @todo2.id.to_s

    item_element = find(todo1_id)     
    new_group_element = find(todo2_id)
    item_element.drag_to new_group_element

    @todo1.reload.priority.should > @todo2.reload.priority
  end
end