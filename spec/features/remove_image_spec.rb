require 'features/features_spec_helper'

feature 'Remove image from task' do
  background do
    @user = FactoryGirl.create :user
    @todo = FactoryGirl.create :todo, user: @user
    @task = FactoryGirl.create :task, todo: @todo
    image = ActionDispatch::Http::UploadedFile.new({
          :filename => 'ruby_motion.jpg',
          :type => 'image/jpeg',
          :tempfile => File.new("#{Rails.root}/spec/support/ruby_motion.jpg")
        })
    @task.update(file_for_task: image)
    login_as @user, scope: :user
    visit root_path
  end

  after do
    @task.destroy
    @todo.destroy
    @user.destroy
  end
  
  scenario 'User remove image from task', :js => true do
    page.find('#mini-image').click
    page.find('#remove-image').click
    wait_for_ajax
    expect(page).not_to have_selector '#mini-image'
    expect(page).to have_selector '#icon-image'
  end
end
