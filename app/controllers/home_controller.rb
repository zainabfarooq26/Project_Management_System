class HomeController < ApplicationController
    def index
    @top_projects = Project.order(total_earnings: :desc).limit(5)
    @bottom_projects = Project.order(total_earnings: :asc).limit(5)
    @monthly_earnings = Payment.group_by_month(:paid_on).sum(:amount)
    @monthly_hours = TimeLog.group_by_month(:created_at).sum(:hours)

    end
end