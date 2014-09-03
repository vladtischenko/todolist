require 'features/features_spec_helper'

feature 'Add task' do
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
  
  scenario 'User adds new task', :js => true do
    text = Faker::Lorem.sentence
    fill_in 'Add task', with: text
    find('input#add-task').native.send_keys(:enter)
    wait_for_ajax
    expect(@todo.tasks.first.reload.text).to eq text
    if text.size < 40
      expect(page).to have_content text
    else
      text = text[0, 37] + '...'
      expect(page).to have_content text
    end
    expect(page).to have_content '1 tasks is not completed'
  end
end
