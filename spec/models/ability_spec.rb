require 'rails_helper'
require "cancan/matchers"

describe Ability do
  let(:user) { FactoryGirl.create :user }
  let(:todo) { FactoryGirl.create :todo, user: user }
  let(:task) { FactoryGirl.create :task, todo: todo }
  let(:ability) { Ability.new(user) }

  context 'can' do
    context 'Todo' do
      it { expect(ability).to be_able_to :new, Todo.new }
      it { expect(ability).to be_able_to :create, Todo.new }
      it { expect(ability).to be_able_to :index, todo }
      it { expect(ability).to be_able_to :update, todo }
      it { expect(ability).to be_able_to :destroy, todo }
    end

    context 'Task' do
      it { expect(ability).to be_able_to :new, Task.new }
      it { expect(ability).to be_able_to :create, Task.new }
      # it { expect(ability).to be_able_to :index, task }
      # it { expect(ability).to be_able_to :update, task }
      # it { expect(ability).to be_able_to :destroy, task }
    end
  end

  context 'cannot' do
    context 'Todo' do
      before do
        todo.user = FactoryGirl.create :user
      end
      it { expect(ability).not_to be_able_to :index, todo }
      it { expect(ability).not_to be_able_to :update, todo }
      it { expect(ability).not_to be_able_to :destroy, todo }
    end
  end

  context 'Task' do
    before do
      task.todo = FactoryGirl.create :todo, user: FactoryGirl.create(:user)
    end
    it { expect(ability).not_to be_able_to :index, task }
    it { expect(ability).not_to be_able_to :update, task }
    it { expect(ability).not_to be_able_to :destroy, task }
  end
end