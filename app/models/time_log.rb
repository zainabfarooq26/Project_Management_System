class TimeLog < ApplicationRecord
  belongs_to :project
  belongs_to :user
  validates :hours, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates:user_id,presence:true
  validates:project_id,presence:true
end
