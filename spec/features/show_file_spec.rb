require 'features/features_spec_helper'

feature 'Show file' do
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

  scenario 'User sees mini-image', :js => true do
    expect(page).to have_selector '#mini-image'
  end

  scenario 'User click on mini image and sees file area and image', :js => true do
    page.find('#mini-image').click
    expect(page).to have_selector 'img#image'
  end

  # background do
  #   image = ActionDispatch::Http::UploadedFile.new({
  #       :filename => 'ruby_motion.jpg',
  #       :type => 'image/jpeg',
  #       :tempfile => File.new("#{Rails.root}/spec/support/ruby_motion.jpg")
  #     })
  #   @task.update(file_for_task: image)
  #   visit current_path
  # end
end
