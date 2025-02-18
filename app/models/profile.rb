class Profile < ApplicationRecord
  validates :first_name, presence: true, allow_nil: true
  validates :last_name, presence: true, allow_nil: true
  belongs_to :user
  has_one_attached :profile_photo
end
