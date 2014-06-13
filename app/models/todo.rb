class Todo < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, dependent: :destroy
  validates :title, :priority, :user_id, presence: true

  scope :by_user, -> (user) {where(user_id: user.id).order(:priority)}
end
