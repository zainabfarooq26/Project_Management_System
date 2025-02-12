class Client < ApplicationRecord
  validates :name, :email, :phone, :address, presence: true
  belongs_to :user  
  has_many :projects

end
