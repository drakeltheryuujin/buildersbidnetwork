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
      self.resource = resource_class.invite!(params[resource_name], current_inviter) do |u|
        u.skip_invitation = true
      end

      if resource.errors.empty?
        subject = "You've Been Invited"
        current_inviter.send_message_with_object_and_type([self.resource], subject, subject, nil, :site_invite)
        set_flash_message :notice, :send_instructions, :email => self.resource.email
        respond_with resource, :location => after_invite_path_for(resource)
      else
        message = ''
        if self.resource.email.blank?
          message = 'Email address required.'
        else
          resource.errors.full_messages.map { |msg| message += msg + '.' }.join
        end
        
        redirect_to after_invite_path_for(resource), :alert => message
      end
    end
  end

  protected

  def after_invite_path_for(resource)
    root_path
  end

end

