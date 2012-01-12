module ProjectsHelper
  def may_admin_project?(project = @project, user = current_user)
    project.may_modify? user
  end

  def has_bid_on_project?(project = @project, user = current_user)
    project.has_bid? user
  end
end
