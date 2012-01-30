class Users::InvitationsController < Devise::InvitationsController

  protected
  def after_invite_path_for(resource)
#after_sign_in_path_for(resource)
    root_path
  end
end

