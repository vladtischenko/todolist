require 'features/features_spec_helper'

feature 'Show file area or file' do
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

  scenario 'User click on icon and see file area', :js => true do
    page.find('#icon-image').click
    expect(page).to have_selector '#file-area'
    expect(page).to have_selector 'input#browse'
  end

  context 'With file' do
    background do
      image = ActionDispatch::Http::UploadedFile.new({
          :filename => 'ruby_motion.jpg',
          :type => 'image/jpeg',
          :tempfile => File.new("#{Rails.root}/spec/support/ruby_motion.jpg")
        })
      @task.update(file_for_task: image)
      visit current_path
    end
    
    scenario 'User see mini-image', :js => true do
      expect(page).to have_selector '#mini-image'
    end
    scenario 'User click on mini image and see file area and image', :js => true do
      page.find('#mini-image').click
      expect(page).to have_selector 'img#image'
    end
  end

end
