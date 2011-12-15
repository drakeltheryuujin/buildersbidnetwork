module ProfilesHelper
  def may_admin_profile?(profile = @profile, user = current_user)
    profile.may_modify? user
  end
end
