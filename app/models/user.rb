class User < ApplicationRecord
  after_create :create_profile
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :active, inclusion: { in: [true, false] }
  has_one_attached :profile_photo
  has_one :profile, dependent: :destroy
  has_many :clients, dependent: :destroy 
  has_many :projects, foreign_key: :manager_id, dependent: :destroy
  def manager?
    is_manager == true
  end
  def locked?
    !self.active? # Returns true if user is inactive (locked)
  end  
  private
  def create_profile
    # Ensure profile is created with default values if none exist
    build_profile(first_name: "Default", last_name: "User") unless self.profile
    self.profile.save! # Save the profile after assigning values
    rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Profile creation failed: #{e.message}"
  end
end
