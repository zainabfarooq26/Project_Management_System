class Comment < ApplicationRecord
  validates :content, presence: true
  validates:user_id,presence:true
  validates:project_id,presence:true
  belongs_to :project
  belongs_to :user
end
