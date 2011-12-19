class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_profile, :only => [:show, :update, :edit, :destroy, :projects, :contact_owner]
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
        format.html { redirect_to(profile_path(@profile), :notice => 'Profile was successfully created.') }
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
    @projects = Project.where(:user_id => @profile.user.id) 
  end

  def contact_owner
    creator = @profile.user
    sender_name = current_user.name
    body = params[:message_body]
    respond_to do |format|
      if body.present?
        subject = "[YPN] Message from #{sender_name}"
        current_user.send_message([creator], body, subject)

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

  private

  def get_profile
    @profile = Profile.find(params[:id])
  end

  def check_may_modify!
    redirect_to(profile_path(@profile), :alert => "Access denied.") unless @profile.may_modify? current_user
  end
end
