class Payment < ApplicationRecord
  after_save :update_project_earnings
  after_destroy :update_project_earnings
  validates :amount, presence: true
  validates :paid_on, presence: true
  validates :status, presence: true, inclusion: { in: %w[paid pending scheduled], message: "%{value} is not a valid status" }
  belongs_to :project
  private
    def update_project_earnings
      project.update!(total_earnings: project.payments.where(status: "paid").sum(:amount))
    end
end
