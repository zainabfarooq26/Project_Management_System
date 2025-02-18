class Payment < ApplicationRecord
  after_save :update_project_earnings
  after_destroy :update_project_earnings
  validates :amount, presence: true
  validates :paid_on, presence: true
  validates :status, presence: true
  enum status: { pending: "pending", scheduled: "scheduled", paid: "paid" }
  belongs_to :project
  private
    def update_project_earnings
      project.update!(total_earnings: project.payments.paid.sum(:amount))
    end
end
