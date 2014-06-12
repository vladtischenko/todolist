require 'rails_helper'

describe Task do
  let(:user) { FactoryGirl.create :user }
  let(:todo) { FactoryGirl.create :todo, user: user }
  let(:task) { FactoryGirl.create :task, todo: todo }

  it { expect(task).to validate_presence_of :text }
  it { expect(task).to validate_presence_of :todo_id }
  it { expect(task).to validate_presence_of :priority }
  it { expect(task).to validate_numericality_of :priority }

  context 'relation' do
    it { expect(task).to belong_to :todo }
  end

  context 'scope' do
    before do
      @tasks = FactoryGirl.create_list :task, 5, todo: FactoryGirl.create(:todo, user: user)
      @task = @tasks.first
      @task.todo = todo
      @task.save 
    end

    it 'returns tasks by todo' do
      expect(Task.by_todo(todo).first.todo).to eq todo
    end
  end
end