class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :active, inclusion: { in: [true, false] }
  has_one_attached :profile_photo
  has_one :profile
  attr_accessor :first_name, :last_name
  def manager?
    is_manager == true
  end
  def locked?
    !self.active? # Returns true if user is inactive (locked)
  end    
  has_many :clients, dependent: :destroy  # A manager can have many clients 
end
