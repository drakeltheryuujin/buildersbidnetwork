class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  
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
    @project = Project.find(params[:id])

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
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    @project.user_id = current_user.id
    @project.state = :draft

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
    @project = Project.find(params[:id])
    @project.state = (@project.state.blank? ? :draft : (params[:publish] ? :published : :draft))

    respond_to do |format|
      if @project.update_attributes(params[:project])
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
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
  
  def contact_creator
    @project = Project.find(params[:id])
    creator = @project.user
    sender_name = (current_user.profile.present?  ? current_user.profile.name : current_user.email)
    body = params[:message_body] || sender_name + " wants to talk about your project."
    subject = "[YPN] Message regarding #{@project.name} from #{sender_name}"
    current_user.send_message([creator], body, subject)
    #creator.notify(subject, body, @project)

    respond_to do |format|
      format.html { redirect_to(@project, :notice => 'Message sent') }
      format.text { render :text => "Message Sent" }
    end
  end

  def review
    @project = Project.find(params[:id])
  end

  def track_projects
    filter = params[:filter]
    if filter.present? && Project::STATES.include?(filter.to_sym)
      @projects = Project.where :user_id => current_user.id, :state => filter
    elsif filter.present? && filter.to_sym == :past
      @projects = Project.where(:user_id => current_user.id).where("bidding_end <= ?", Time.now)
    elsif filter.present? && filter.to_sym == :future
      @projects = Project.where(:user_id => current_user.id).where("bidding_start >= ?", Time.now)
    elsif filter.present? && filter.to_sym == :current
      @projects = Project.
          where(:user_id => current_user.id).
          where("bidding_start <= ?", Time.now).
          where("bidding_end >= ?", Time.now)
    else
      @projects = Project.find_all_by_user_id current_user.id
    end
  end

  def track_bids 
    @bids = Bid.find_all_by_user_id current_user.id
  end
end
