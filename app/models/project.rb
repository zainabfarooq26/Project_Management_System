class Project < ApplicationRecord
  belongs_to :manager, class_name: "User"
  validates :title, presence: true
  validates :description, presence: true
  has_many_attached :attachments

end
