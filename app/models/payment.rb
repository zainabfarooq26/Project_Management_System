class Payment < ApplicationRecord
  belongs_to :project
  validates :amount, presence: true
  validates :paid_on, presence: true
  validates :status, presence: true, inclusion: { in: %w[paid pending scheduled], message: "%{value} is not a valid status" }

end
