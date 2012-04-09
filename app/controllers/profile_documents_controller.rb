class ProfileDocumentsController < ApplicationController
	before_filter :authenticate_user!
  before_filter :get_profile_and_document, :only => [:show, :update, :edit, :destroy]
  before_filter :check_may_modify!, :only => [:update, :edit, :destroy]

  def index
  end

  def destroy
    @profile_document.destroy
    redirect_to(profile_path(@profile), :notice => 'ProfileDocument was successfully destroyed.')
	end

  def show
    redirect_to profile_path(@profile_document.profile)
  end
  
  def edit
    redirect_to profile_path(@profile_document.profile)
  end
  
  def new
    @profile_id = params[:developer_profile_id].nil? ? params[:contractor_profile_id] : params[:developer_profile_id]
    @profile = Profile.find(profile_id)
  end
  
  def create
    @profile_id = params[:developer_profile_id].nil? ? params[:contractor_profile_id] : params[:developer_profile_id]
    
    @profile = Profile.find(@profile_id)
    @profile_document = ProfileDocument.create(params[:profile_document])
    @profile_document.profile = @profile
    
    if @profile_document.save
      redirect_to(profile_path(@profile), :notice => 'ProfileDocument was successfully created.')
    else
      redirect_to(profile_path(@profile), :alert => @profile_document.errors.full_messages.join(' ') + 'ProfileDocument could not be created.')
    end
  end
  
  def update
    if @profile_document.update_attributes(params[:profile_document])
      respond_to do |format|
        format.text { render :text => @profile_document.description }
        format.html { redirect_to(profile_path(@profile_document.profile), :notice => 'ProfileDocument was successfully updated.') }
      end
    else
      respond_to do |format|
        format.text { render :text => "Error updating description.", :status => :bad_request }
        format.html { redirect_to(profile_path(@profile_document.profile), :alert => 'ProfileDocument could not be updated.') }
      end
    end
  end

  private

  def get_profile_and_document
    @profile_id = params[:developer_profile_id].nil? ? params[:contractor_profile_id] : params[:developer_profile_id]
    @profile = Profile.find(@profile_id)
    @profile_document = ProfileDocument.find(params[:id])
  end

  def check_may_modify!
    redirect_to(profile_path(@profile), :alert => "Access denied.") unless @profile.may_modify? current_user
  end
end
