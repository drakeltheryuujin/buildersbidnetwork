class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_profile, :only => [:show, :update, :edit, :destroy, :projects, :contact_owner, :invite, :add_cover_photo, :documents]
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
    if li_auth = current_user.linkedin_auth
      @avatar_url = li_auth.avatar_url
      # fetch fields from the user's linkedin profile
      li_client = li_auth.linkedin_client
      li_profile = li_client.profile(:fields => %w(three_current_positions formatted_name summary location phone_numbers main_address))

      if li_profile.present?
        # use current position's company, or the user's name if company unavailable
        if li_profile['three_current_positions'].total > 0
          @profile.name = li_profile['three_current_positions'].all.first.company.name
        else
          @profile.name = li_profile['formatted_name']
        end

        # description/summary
        @profile.description = li_profile['summary']

        # phone numbers
        if li_profile['phone_numbers'].total > 0
          li_profile['phone_numbers'].all.each do |p|
            phone = @profile.phones.build(
                :number => p['phone_number'], 
                :phone_type => PhoneType.find_by_name_or_default(p['phone_type']))
          end
        end

        # TODO address.  li_profile['main_address'] is a multi-line address string.  needs parsed.
      end
    end
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
        @profile.user.send_welcome_notification
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
    # FIXME There's probably a better way to manage STI.
    profile_params = (@profile.type == DeveloperProfile.to_s ? params[:developer_profile] : params[:contractor_profile])
    profile_params[:project_type_ids] ||= []

    respond_to do |format|
      if @profile.update_attributes(profile_params)
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
      @projects = @profile.user.project.not_deleted.published.where(:private => false).order('created_at DESC')
    else
      @projects = Project.joins(:bids).where(:private => false, :deleted_at => nil, :bids => {:user_id => @profile.user.id, :state => :accepted.to_s, :deleted_at => nil})
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
    pids = params['project_ids']
    if pids.present?
      projects = pids.collect { |pid| Project.find pid }
      privs = []
      projects.each do |project|
        project_privilege = project.project_privileges.build(:user => invitee, :message_body => params[:message_body])
        privs << project_privilege if project_privilege.save
      end
      message = "User invited to: " + privs.collect { |priv| priv.project.name }.join(', ')
      respond_to do |format|
        format.html { return redirect_to(@profile, :notice => message) }
        format.text { return render :text => message }
      end
    else
      message = "Please select one or more project to invite this user to."
      respond_to do |format|
        format.html { return redirect_to(@profile, :alert => message) }
        format.text { return render :text => message, :status => :bad_request }
      end
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
    @profile = Profile.not_deleted.find(params[:id])
  end

  def check_may_modify!
    redirect_to(profile_path(@profile), :alert => "Access denied.") unless @profile.may_modify? current_user
  end

  def check_not_deleted!
    raise ActiveRecord::RecordNotFound.new('Not Found') unless @profile.deleted_at.blank?
  end

  def documents 
    
  end
end
