class Project < ApplicationRecord
  belongs_to :manager, class_name: "User" 
  has_many :payments, dependent: :destroy 
  belongs_to :client
  has_many_attached :attachments
  has_many :time_logs, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  validates :title, presence: true
  validates :description, presence: true
end
