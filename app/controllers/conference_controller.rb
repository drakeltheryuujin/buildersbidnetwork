class ConferenceController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @user = User.new
    @profile = @user.build_profile
    #@profile.build_location
    #@phone = @profile.phones.build
    #@phone.phone_type = PhoneType.find 1
  end
  
  def create
    @user = User.new(params[:user])

    # deeper nesting confuses accepts_nested_attributes_for, so we manually instantiate Location
    if params[:user][:profile].present?
      location = Location.new(params[:user][:profile].delete(:location)) 
      if DeveloperProfile.to_s == params[:user][:profile][:type]
        @profile = DeveloperProfile.new(params[:user][:profile])
      elsif ContractorProfile.to_s == params[:user][:profile][:type]
        @profile = ContractorProfile.new(params[:user][:profile])
      end
    elsif params[:user][:developer_profile].present?
      location = Location.new(params[:user][:developer_profile].delete(:location)) 
      @profile = DeveloperProfile.new(params[:user][:developer_profile])
    elsif params[:user][:contractor_profile].present?
      location = Location.new(params[:user][:contractor_profile].delete(:location)) 
      @profile = ContractorProfile.new(params[:user][:contractor_profile])
    end
    @profile.location = location

    @user.profile = @profile

    if @user.save
      @user.send_welcome_notification

      redirect_to(conference_index_path(@profile), :notice => 'Profile was successfully created.') 
    else
      render :action => :index
    end
  end
end
