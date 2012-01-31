class Users::InvitationsController < Devise::InvitationsController
  include DeviseHelper
  include ActionView::Helpers::TextHelper

  def create
    y params
    if params[resource_name][:emails].present?
      emails = params[resource_name][:emails].split(/\s*,\s*/)

      success = []
      failure = []
      emails.each do |email|
        puts email
        u = User.invite!({:email => email}, current_inviter)
        if u.errors.empty?
          puts "suc " + u.to_s
          success << u
        else
          puts "fail " + u.to_s
          failure << u
        end
      end
      respond_to do |format|
        if failure.empty?
          message = pluralize(success.size(), "invitation") + " sent."
          puts "WORKED" + message
          format.html {
            set_flash_message :notice, message
            respond_with resource, :location => after_invite_path_for(resource)
          }
          format.text { render :text => message }
        else
          puts "FAILED"
          message = ""
          failure.each do |f|
            puts ">>>" + f.to_s
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
      super
    end
  end

  protected

  def after_invite_path_for(resource)
    root_path
  end

end

