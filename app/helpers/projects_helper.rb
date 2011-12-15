module ProjectsHelper
  def may_admin_project?(project = @project, user = current_user)
    project.may_modify? user
  end
end
