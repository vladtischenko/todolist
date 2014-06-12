require 'carrierwave/orm/activerecord'

class Task < ActiveRecord::Base
  belongs_to :todo
  mount_uploader :file, FileForTaskUploader
  validates :text, :priority, :todo_id, presence: true
  validates :priority, numericality: true
  # validates :text, :priority, :complete, :todo_id, presence: true

  scope :by_todo, -> (todo_id) {where(todo_id: todo_id)}
end
