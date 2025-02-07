class Project < ApplicationRecord
  belongs_to :manager, class_name: "User" 
  has_many :payments, dependent: :destroy 
  belongs_to :client
  has_many_attached :attachments
  has_many :time_logs, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :users
  validates :title, presence: true
  validates :description, presence: true
end
