class Client < ApplicationRecord
  belongs_to :user  # Each client is associated with a manager
  validates :name, :email, :phone, :address, presence: true
end
