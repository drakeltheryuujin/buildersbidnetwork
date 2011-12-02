module ProfilesHelper
  def may_admin_profile?(profile = @profile, user = current_user)
    profile.user == user
  end
end
