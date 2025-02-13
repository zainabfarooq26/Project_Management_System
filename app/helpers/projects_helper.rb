module ProjectsHelper
  def find_project(project_id)
    Project.find_by(id: project_id)
  end

  def non_admin_users
    User.where.not(admin: true)
  end
end
