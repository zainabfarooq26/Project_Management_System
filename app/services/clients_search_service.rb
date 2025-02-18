class ClientsSearchService
    def initialize(clients, search_query, search_category)
      @clients = clients
      @search_query = search_query
      @search_category = search_category
    end

    def call
      return @clients if @search_query.blank?
      query = "%#{@search_query}%"
      case @search_category
      when "name"
        @clients = @clients.where("clients.name ILIKE ?", query)
      when "email"
        @clients = @clients.where("clients.email ILIKE ?", query)
      when "phone"
        @clients = @clients.where("clients.phone ILIKE ?", query)
      when "address"
        @clients = @clients.where("clients.address ILIKE ?", query)
      when "project_title"
        @clients = @clients.joins(:projects).where("projects.title ILIKE ?",
         query).distinct
      else
        @clients = @clients.left_joins(:projects).where(
          "clients.name ILIKE ? OR clients.email ILIKE ? OR clients.phone ILIKE ? 
          OR clients.address ILIKE ? OR projects.title ILIKE ?", query, query,
           query, query, query ).distinct
      end
      @clients
    end
end