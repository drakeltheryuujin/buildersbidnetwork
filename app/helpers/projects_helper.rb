module ProjectsHelper
  def may_admin?
    @project.user == current_user
  end
end
