class User < ApplicationRecord
  after_create :create_profile
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :active, inclusion: { in: [true, false] }
  has_one_attached :profile_photo
  has_one :profile, dependent: :destroy
  has_many :clients
  has_many :project_assignments
  has_and_belongs_to_many :projects, through: :project_assignments, dependent: :destroy
  has_many :time_logs, dependent: :destroy
  has_many :comments, dependent: :destroy
  enum role: { user: 0, manager: 1, admin: 2 }

  scope :not_admin, -> { where(admin: false) }

  def locked?
    !self.active? 
  end  
  def assigned_to?(project)
    projects.exists?(project.id)
  end
  private
  def create_profile
    build_profile(first_name: "Default", last_name: "User") unless self.profile
    self.profile.save! 
  end
end