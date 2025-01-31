class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :active, inclusion: { in: [true, false] }
  def locked?
    !self.active? # Returns true if user is inactive (locked)
  end    
    has_many :clients, dependent: :destroy  # A manager can have many clients 
end
