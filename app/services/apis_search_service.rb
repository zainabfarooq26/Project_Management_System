class ApisSearchService

    def initialize(params)
      @params = params
      @projects = Project.all
    end

    def search
      filter_by_title
      filter_by_description
      filter_by_date_range
      limit_results
      @projects
    end
    
    private
    def filter_by_title
      @projects = @projects.where("title LIKE ?", "%#{@params[:title]}%") if @params[:title].present?
    end
  
    def filter_by_description
      @projects = @projects.where("description LIKE ?", "%#{@params[:description]}%") if @params[:description].present?
    end

    def filter_by_date_range
      if @params[:start_date].present? && @params[:end_date].present?
        @projects = @projects.where("created_at BETWEEN ? AND ?", @params[:start_date], @params[:end_date])
      end
    end
  
    def limit_results
      @projects = @projects.limit(100)  
    end
end