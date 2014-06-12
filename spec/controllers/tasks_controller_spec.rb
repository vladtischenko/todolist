require 'rails_helper'

describe TasksController do
  include Devise::TestHelpers

  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub(:current_ability).and_return(@ability)
  end

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create :user
    sign_in @user

    @todo = FactoryGirl.create :todo, user: @user
    @tasks = FactoryGirl.create_list :task, 3, todo: @todo
    @task = @tasks.first
    @task_params = {"text"=>@task.text, "complete"=>@task.complete, "priority"=>@task.priority}
    @json = { format: :json, task: {todo_id: @task.todo_id, priority: @task.priority, text: @task.text} }
    Task.stub(:by_todo).and_return(@tasks)
  end

  context 'not authorized user' do
    before do
      sign_out @user
    end
    it 'cannot index tasks' do
      @ability.cannot :index, Task
    end
    it 'cannot create task' do
      @ability.cannot :create, Task
    end
    it 'cannot update task' do
      @ability.cannot :update, Task
    end
    it 'cannot destroy task' do
      @ability.cannot :destroy, Task
    end
  end

  context 'GET index' do
    it 'renders json tasks' do
      @ability.can :index, Task
      get :index, format: :json
      expect(JSON.parse(response.body).to_json).to eq @tasks.to_json
    end
  end

  context 'POST create' do
    before do
      @ability.can :create, Task
    end
    it 'renders json task if successfully created' do
      post :create, @json
      expect(JSON.parse(response.body)['text']).to eq(@json[:task][:text])
    end
    it 'renders json task.errors unless task successfully created' do
      @json[:task][:text] = nil
      post :create, @json
      expect(JSON.parse(response.body)['text']).to eq ["can't be blank"]
    end
  end

  context 'PATCH update' do
    before do
      @ability.can :update, Task
    end
    it 'renders json task if successfully updated' do
      patch :update, id: @task.id, task: @task_params, format: :json
      expect(JSON.parse(response.body)['text']).to eq(@json[:task][:text])
    end
    it 'renders json task.errors unless successfully updated' do
      @task_params['priority'] = nil
      patch :update, id: @task.id, task: @task_params, format: :json
      expect(JSON.parse(response.body)['priority']).to eq ["can't be blank", "is not a number"]
    end
  end

  context 'DELETE destroy' do
    before do
      @ability.can :destroy, Task
    end
    it { expect { delete :destroy, format: :json, id: @task.id }.to change(Task, :count).by(-1) }
  end
end
