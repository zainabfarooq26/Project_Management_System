class ProjectsSearchService
    def initialize(client, search_query, search_category, sort_order)
      @client = client
      @search_query = search_query.to_s.strip.presence
      @search_category = search_category.to_s.strip.presence
      @sort_order = sort_order
    end
    def call
      projects = @client.projects.left_joins(:users).distinct
      projects = apply_search(projects) if @search_query.present?
      projects = apply_sorting(projects)
      projects
    end
    private
    def apply_search(projects)
      query = "%#{@search_query}%"
      if @search_category.blank?
        projects.where(
          "projects.title ILIKE :query OR users.first_name ILIKE :query OR users.last_name ILIKE :query OR users.email ILIKE :query",
          query: query
        )
      else
        case @search_category
        when "title"
          projects.where("projects.title ILIKE ?", query)
        when "user"
          projects.where("users.first_name ILIKE :query OR users.last_name ILIKE :query OR users.email ILIKE :query", query: query)
        else
          projects
        end
      end
    end
    def apply_sorting(projects)
      case @sort_order
      when "highest_paid"
        projects.order(total_earnings: :desc)
      when "lowest_paid"
        projects.order(total_earnings: :asc)
      else
        projects
      end
    end
  end
  