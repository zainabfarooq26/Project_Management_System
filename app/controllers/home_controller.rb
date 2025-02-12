class HomeController < ApplicationController
    def index
    @top_projects = Project.order(total_earnings: :desc).limit(5)
    @bottom_projects = Project.order(total_earnings: :asc).limit(5)
    @monthly_earnings = Payment.paid.group_by_month(:paid_on, format: "%b %Y").sum(:amount) || {}
    @monthly_hours = Payment.paid.group_by_month(:paid_on, format: "%b %Y").sum(:hours) || {}
    

    end
end