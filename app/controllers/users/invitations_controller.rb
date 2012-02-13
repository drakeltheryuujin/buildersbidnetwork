class Users::InvitationsController < Devise::InvitationsController
  include DeviseHelper
  include ActionView::Helpers::TextHelper

  def create
    # this is a never completed attempt at accepting multiple email addresses at once
    if params[resource_name][:emails].present?
      emails = params[resource_name][:emails].split(/\s*,\s*/)

      success = []
      failure = []
      emails.each do |email|
        u = User.invite!({:email => email}, current_inviter)
        if u.errors.empty?
          success << u
        else
          failure << u
        end
      end
      respond_to do |format|
        if failure.empty?
          message = pluralize(success.size(), "invitation") + " sent."
          format.html {
            set_flash_message :notice, message
            respond_with resource, :location => after_invite_path_for(resource)
          }
          format.text { render :text => message }
        else
          message = ""
          failure.each do |f|
            message += error_for_res(f)
          end
          format.html {
            set_flash_message :alert, message
            respond_with_navigational(resource) { render_with_scope :new }
          }
          format.text { render :text => message, :status => :bad_request }
        end
      end
    else
      self.resource = resource_class.invite!(params[resource_name], current_inviter)

      if resource.errors.empty?
        set_flash_message :notice, :send_instructions, :email => self.resource.email
        respond_with resource, :location => after_invite_path_for(resource)
      else
        redirect_to after_invite_path_for(resource), :alert => (self.resource.email.blank? ? 'Email address required.' : self.resource.email + ' is not a valid email address.')
      end
    end
  end

  protected

  def after_invite_path_for(resource)
    root_path
  end

end

