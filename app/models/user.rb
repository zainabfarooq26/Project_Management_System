class User < ApplicationRecord
  after_create :create_profile
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :active, inclusion: { in: [true, false] }
  has_one_attached :profile_photo
  has_one :profile, dependent: :destroy
  has_many :clients, dependent: :destroy 
  def manager?
    is_manager == true
  end
  def locked?
    !self.active? # Returns true if user is inactive (locked)
  end  
  private
  def create_profile
    self.create_profile!(
      first_name: '',
      last_name: ''
    ) # Creates a profile without the `name` column
  end
end
