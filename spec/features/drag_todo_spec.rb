require 'features/features_spec_helper'

feature 'Drag todo' do
  background do
    @user = FactoryGirl.create :user
    @todo1 = FactoryGirl.create :todo, user: @user
    @todo2 = FactoryGirl.create :todo, user: @user, priority: @todo1.priority + 1 
    login_as @user, scope: :user
    visit root_path
  end
  
  after do
    @todo2.destroy
    @todo1.destroy
    @user.destroy
  end

  scenario 'User drags todos', :js => true, :retry => 2, :retry_wait => 2 do
    todo1_id = '#todo' + @todo1.id.to_s
    todo2_id = '#todo' + @todo2.id.to_s

    item_element = find(todo1_id)     
    new_group_element = find(todo2_id)
    item_element.drag_to new_group_element

    wait_for_ajax
    
    @todo1.reload
    @todo2.reload

    @todo1.priority.should > @todo2.priority
  end
end