class Client < ApplicationRecord
  belongs_to :user  
  validates :name, :email, :phone, :address, presence: true
  has_many :projects

end
