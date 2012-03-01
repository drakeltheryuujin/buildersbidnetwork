class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_profile, :only => [:show, :update, :edit, :destroy, :projects, :contact_owner, :invite, :add_cover_photo]
  before_filter :check_may_modify!, :only => [:update, :edit, :destroy, :review]

  # GET /profiles
  # GET /profiles.xml
  def index
    @profiles = Profile.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profiles }
    end
  end

  # GET /profiles/1
  # GET /profiles/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  # GET /profiles/new
  # GET /profiles/new.xml
  def new
    @profile = Profile.new
    @profile.build_location
    @phone = @profile.phones.build
    @phone.phone_type = PhoneType.find 1
    

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles
  # POST /profiles.xml
  def create
    if ! params[:profile].blank? && DeveloperProfile.to_s == params[:profile][:type]
      @profile = DeveloperProfile.new(params[:profile])
    elsif ! params[:profile].blank? && ContractorProfile.to_s == params[:profile][:type]
      @profile = ContractorProfile.new(params[:profile])
    elsif ! params[:developer_profile].blank?
      @profile = DeveloperProfile.new(params[:developer_profile])
    elsif ! params[:contractor_profile].blank?
      @profile = ContractorProfile.new(params[:contractor_profile])
    end
    @profile.user_id = current_user.id
    @profile.website = nil

    respond_to do |format|
      if @profile.save
        format.html { 
          if(current_user.sign_in_count == 1 && current_user.invited_project.present?)
            redirect_to(project_path(current_user.invited_project), :notice => 'Your profile was successfully created. Here are is the project you were invited to bid on.') 
          elsif(current_user.sign_in_count == 1 && current_user.invited_by.present?) 
            redirect_to(projects_profile_path(current_user.invited_by.profile), :notice => 'Your profile was successfully created. Here are some projects from the user that invited you.') 
          else
            redirect_to(profile_path(@profile), :notice => 'Profile was successfully created.') 
          end
        }
        format.xml  { render :xml => @profile, :status => :created, :location => @profile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.xml
  def update
    respond_to do |format|
      # FIXME There's probably a better way to do this.
      if @profile.update_attributes(@profile.type == DeveloperProfile.to_s ? params[:developer_profile] : params[:contractor_profile])
        format.html { redirect_to(profile_path(@profile), :notice => 'Profile was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.xml
  def destroy
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to(profiles_url) }
      format.xml  { head :ok }
    end
  end

  def projects
    if @profile.user.developer?
      @projects = @profile.user.project.published.where(:private => false)
    else
      @projects = Project.joins(:bids).where(:private => false, :bids => {:user_id => @profile.user.id, :state => :accepted.to_s})
    end
  end

  def contact_owner
    creator = @profile.user
    sender_name = current_user.name
    body = params[:message_body]
    respond_to do |format|
      if body.present?
        subject = "Message from #{sender_name}"
        current_user.send_message_with_object_and_type([creator], body, subject, @profile, :profile_message)

        message = 'Message sent.'
        format.html { redirect_to(@profile, :notice => message) }
        format.text { render :text => message }
      else
        message = 'Must include a message to send.'
        format.html { redirect_to(@profile, :alert => message) }
        format.text { render :text => message, :status => :bad_request }
      end
    end
  end

  def invite
    invitee = @profile.user
    project = Project.find(params[:project_id])
    respond_to do |format|
      if project.present?
        project_privilege = project.project_privileges.build(:user => invitee, :message_body => params[:message_body])
        if project_privilege.save
          message = 'User invited.'
          format.html { return redirect_to(@profile, :notice => message) }
          format.text { return render :text => message }
        else
          message = project_privilege.errors.full_messages.join(', ')
        end
      else
        message = 'Invalid project'
      end
      format.html { redirect_to(@profile, :alert => message) }
      format.text { render :text => message, :status => :bad_request }
    end
  end
  
  def add_cover_photo
    if @profile.present?
      @profile.update_attribute(:asset, params[:asset])
    end
    
    if @profile.save!
      redirect_to profile_path(@profile), :notice => 'Profile was successfully updated.'
    else
      redirect_to profile_path(@profile), :alert => 'Profile was not successfully updated.'
    end
  end
  
  private

  def get_profile
    @profile = Profile.find(params[:id])
  end

  def check_may_modify!
    redirect_to(profile_path(@profile), :alert => "Access denied.") unless @profile.may_modify? current_user
  end
end
