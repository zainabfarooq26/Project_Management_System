class Project < ApplicationRecord
  belongs_to :manager, class_name: "User"
  has_many :payments, dependent: :destroy 
  validates :title, presence: true
  validates :description, presence: true
  has_many_attached :attachments

end
