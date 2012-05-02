class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create]

  def index
    # get all authentication services assigned to the current user
    @authentications = current_user.authentications.all
    @linkedin_auth = current_user.linkedin_auth
  end

  def destroy
    # remove an authentication service linked to the current user
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    
    redirect_to authentications_path
  end

  def create
    # get the service parameter from the Rails router
    params[:service] ? service_route = params[:service] : service_route = 'no service (invalid callback)'

    # get the full hash from omniauth
    omniauth = request.env['omniauth.auth']

    # continue only if hash and parameter exist
    if omniauth.present? and service_route.present?
      uid =  omniauth['uid']
      provider =  omniauth['provider']
      # extract user information
      if omniauth['credentials']
        token = omniauth['credentials']['token']
        secret = omniauth['credentials']['secret']
      end
      if omniauth['info']
        avatar_url = omniauth['info']['image']
        name = omniauth['info']['name']
        if omniauth['info']['urls']
          profile_url = omniauth['info']['urls']['public_profile']
        end
      end

      # apply
      if uid.present? && provider.present?
        auth = Authentication.find_by_provider_and_uid(provider, uid)
        if auth.present?
          auth.update_attributes(
              :token => (token.blank? ? auth.token : token),
              :secret => (secret.blank? ? auth.secret : secret),
              :avatar_url => (avatar_url.blank? ? auth.avatar_url : avatar_url),
              :name => (name.blank? ? auth.name : name),
              :profile_url => (profile_url.blank? ? auth.profile_url : profile_url)) unless token.blank? && secret.blank? && avatar_url.blank? && name.blank? && profile_url.blank?
          if user_signed_in? # already linked
            flash[:notice] = authentication_route.capitalize + ' authentication updated.'
            redirect_to authentications_path
          else # signing in
            flash[:notice] = 'Signed in successfully via ' + provider.capitalize + '.'
            sign_in_and_redirect(:user, auth.user)
          end
        else # no existing authentication
          auth_hash = {
              :provider => provider, 
              :uid => uid, 
              :token => token, 
              :secret => secret, 
              :avatar_url => avatar_url,
              :name => name,
              :profile_url => profile_url}
          if user_signed_in? # link accounts
            current_user.authentications.create(auth_hash)
            flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account.'
            redirect_to authentications_path
          else # new registration
            flash[:notice] = 'Great!  Please provide your email address and choose a password to complete your registration with ' + provider.capitalize + '.'
            flash[:avatar_url] = avatar_url
            session["devise.omniauth_authentication"] = auth_hash
            redirect_to new_user_registration_path
          end
        end
      else
        flash[:error] =  service_route.capitalize + ' returned invalid data for the user id.'
        redirect_to new_user_session_path
      end
    else
      flash[:error] = 'Error while authenticating via ' + service_route.capitalize + '.'
      redirect_to new_user_session_path
    end
  end
end
