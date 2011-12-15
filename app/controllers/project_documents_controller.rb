class ProjectDocumentsController < ApplicationController
	before_filter :authenticate_user!
  before_filter :get_project_and_document, :only => [:show, :update, :edit, :destroy]
  before_filter :check_may_modify!, :only => [:update, :edit, :destroy]

  def index
  end

  def destroy
    @project_document.destroy
    redirect_to(project_path(@project), :notice => 'ProjectDocument was successfully destroyed.')
	end

  def show
    redirect_to project_path(@project_document.project)
  end
  
  def edit
    redirect_to project_path(@project_document.project)
  end
  
  def new
    @project = Project.find(params[:project_id])
  end
  
  def create
    @project = Project.find(params[:project_id])
    @project_document = ProjectDocument.create(params[:project_document])
    @project_document.project = @project
    
    if @project_document.save
      redirect_to(project_path(@project), :notice => 'ProjectDocument was successfully created.')
    else
      redirect_to(project_path(@project), :alert => 'ProjectDocument could not be created.')
    end
  end
  
  def update
    if @project_document.update_attributes(params[:project_document])
      redirect_to(project_path(@project_document.project), :notice => 'ProjectDocument was successfully updated.')
    else
      redirect_to(project_path(@project_document.project), :alert => 'ProjectDocument could not be updated.')
    end
  end

  private

  def get_project_and_document
    @project = Project.find(params[:project_id])
    @project_document = ProjectDocument.find(params[:id])
  end

  def check_may_modify!
    redirect_to(project_path(@project), :alert => "Access denied.") unless @project.may_modify? current_user
  end
end
