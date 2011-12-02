module ProjectsHelper
  def may_admin_project?(project = @project, user = current_user)
    project.user == user
  end
end
