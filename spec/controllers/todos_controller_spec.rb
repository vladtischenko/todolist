require 'rails_helper'

describe TodosController do
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
    @todo_params = {"title"=>@todo.title, "priority"=>@todo.priority, "user_id"=>@todo.user_id}
    @todos = FactoryGirl.create_list :todo, 3, user: @user
    @json = { format: :json, todo: {user_id: @todo.user_id, priority: @todo.priority, title: @todo.title} }
    Todo.stub(:by_user).and_return(@todos)
  end

  context 'not authorized user' do
    before do
      sign_out @user
    end
    it 'cannot index todos' do
      @ability.cannot :index, Todo
    end
    it 'cannot create todo' do
      @ability.cannot :create, Todo
    end
    it 'cannot update todo' do
      @ability.cannot :update, Todo
    end
    it 'cannot destroy todo' do
      @ability.cannot :destroy, Todo
    end
  end

  context 'GET index' do
    it 'renders json todos' do
      @ability.can :index, Todo
      get :index, format: :json
      expect(JSON.parse(response.body).to_json).to eq @todos.to_json
    end
  end

  context 'POST create' do
    before do
      @ability.can :create, Todo
    end
    it 'renders json todo if successfully todo created' do
      post :create, @json
      expect(JSON.parse(response.body)['user_id']).to eq(@json[:todo][:user_id])
    end
    it 'renders json.errors unless successfully created' do
      @json[:todo][:title] = nil
      post :create, @json
      expect(JSON.parse(response.body)['title']).to eq ["can't be blank"]
    end
  end

  context 'PATCH update' do
    before do
      @ability.can :update, Todo
    end
    it 'renders json todo if successfully updated' do
      patch :update, id: @todo.id, todo: @todo_params, format: :json
      expect(JSON.parse(response.body)['title']).to eq(@json[:todo][:title])
    end
    it 'renders json.errors unless successfully updated' do
      @todo_params['title'] = nil
      patch :update, id: @todo.id, todo: @todo_params, format: :json
      expect(JSON.parse(response.body)['title']).to eq ["can't be blank"]
    end
  end

  context 'DELETE destroy' do
    before do
      @ability.can :destroy, Todo
    end
    it { expect { delete :destroy, format: :json, id: @todo.id }.to change(Todo, :count).by(-1) }
  end
end
