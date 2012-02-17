class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_project, :only => [:show, :update, :edit, :destroy, :contact_creator, :review, :update_cover_photo]
  before_filter :check_may_access!, :only => [:show, :update, :edit, :destroy, :contact_creator, :review, :update_cover_photo]
  before_filter :check_may_modify!, :only => [:update, :edit, :destroy, :review]
  
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
    if(cover_photo.present? && cover_photo.project == @project)
      @project.update_attribute(:cover_photo, cover_photo)
    end
    
    redirect_to project_path(@project, :anchor => 'photos')
  end

  def manage_access
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
