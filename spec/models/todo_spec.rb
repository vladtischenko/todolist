require 'rails_helper'

describe Todo do
  let(:user) { FactoryGirl.create :user }
  let(:todo) { FactoryGirl.create :todo, user: user }

  it { expect(todo).to validate_presence_of :title }
  it { expect(todo).to validate_presence_of :priority }

  context 'relation' do
    it { expect(todo).to have_many :tasks }
    it { expect(todo).to belong_to :user }
  end

  context 'scope' do
    before do
      @todos = FactoryGirl.create_list :todo, 5, user: FactoryGirl.create(:user)
      @todo = @todos.first
      @todo.user = user
      @todo.save
    end

    it "returns todos by user" do
      expect(Todo.by_user(user).first.user).to eq user 
    end
  end
end