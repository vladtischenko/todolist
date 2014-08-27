require 'carrierwave/orm/activerecord'

class Task < ActiveRecord::Base
  belongs_to :todo
  mount_uploader :file_for_task, FileForTaskUploader
  # has_attached_file :file_for_task, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates :text, :priority, :todo_id, presence: true
  validates :priority, numericality: true
  # validates :text, :priority, :complete, :todo_id, presence: true

  scope :by_todo, -> (todo_id) {where(todo_id: todo_id).order(:priority)}
end
