class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_project, :only => [:show, :update, :edit, :destroy, :contact_creator, :review, :update_cover_photo, :manage_access, :revoke_access, :invite_by_email]
  before_filter :check_may_access!, :only => [:show, :update, :edit, :destroy, :contact_creator, :review, :update_cover_photo]
  before_filter :check_may_modify!, :only => [:update, :edit, :destroy, :review, :manage_access, :revoke_access]
  
  # GET /projects
  # GET /projects.xml
  def index
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new
    @project.build_location
    @project.line_items.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    @project.user_id = current_user.id

    respond_to do |format|
      if @project.save and @project.location.save
        format.html { redirect_to(new_project_project_document_path(@project), :notice => 'Project was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project.publish if params[:publish].present?
    @project.cancel if params[:cancel].present?

    respond_to do |format|
      if @project.update_attributes(params[:project])
        @project.hold_bids_and_notify_bidders(render_to_string(:partial => "project_changed", :layout => false))
        format.html { redirect_to(@project, :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
  
  def contact_creator
    creator = @project.user
    sender_name = current_user.name
    body = params[:message_body] || sender_name + " wants to talk about your project."
    subject = "Message regarding #{@project.name} from #{sender_name}"
    current_user.send_message_with_object_and_type([creator], body, subject, @project, :project_message)
    #creator.notify(subject, body, @project)

    respond_to do |format|
      format.html { redirect_to(@project, :notice => 'Message sent') }
      format.text { render :text => "Message Sent" }
    end
  end

  def review
  end

  def update_cover_photo
    cover_photo = ProjectDocument.find_by_id params[:selected_project_document_id]
    if(cover_photo.present? && cover_photo.project == @project && cover_photo.project.user.id == @project.user.id)
      @project.update_attribute(:cover_photo, cover_photo)
    end
    
    redirect_to project_path(@project, :anchor => 'photos')
  end

  def manage_access
  end
  
  def revoke_access
    user = User.find params[:user_id]
    pp = ProjectPrivilege.find_by_user_id_and_project_id(user.id, @project.id)
    unless pp.blank?
      pp.destroy
      flash[:notice] = 'Access revoked'
    end
    redirect_to manage_access_project_path(@project), :notice => 'Access revoked'
  end

  def invite_by_email
    user = User.find_by_email params[:email_address]
    unless user.present?
      user = User.invite!({:email => params[:email_address], :message_body => params[:message_body]}, current_user) do |invited_user|
        invited_user.skip_invitation = true
        invited_user.invited_project = @project
      end
    end
    if user.developer?
      flash[:alert] = "#{user.email} is registered as a Developer on BBN.  Only Contractors can Bid on Projects."
    elsif user.errors.empty?
      project_privilege = ProjectPrivilege.where(:user_id => user.id, :project_id => @project.id)
      unless project_privilege.present?
        project_privilege = ProjectPrivilege.new(:user => user, :project => @project, :message_body => params[:message_body])
        if project_privilege.save
          flash[:notice] = 'User invited.'
        else
          flash[:alert] = project_privilege.errors.full_messages.join(', ')
        end
      else
        flash[:alert] = 'Already invited.'
      end
    else
      flash[:alert] = user.errors.full_messages.join(', ')
    end

    redirect_to manage_access_project_path(@project)
  end
  
  private

  def get_project
    @project = Project.find(params[:id])
  end

  def check_may_access!
    redirect_to(search_index_path, :alert => "Access denied.") unless @project.may_access? current_user
  end

  def check_may_modify!
    redirect_to(project_path(@project), :alert => "Access denied.") unless @project.may_modify? current_user
  end
end
