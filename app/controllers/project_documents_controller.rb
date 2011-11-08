class ProjectDocumentsController < ApplicationController
	before_filter :authenticate_user!

  def index
  end

  def destroy
    @project = Project.find(params[:project_id])
    @project_document = ProjectDocument.find(params[:id])
    @project_document.destroy
    redirect_to(project_path(@project), :notice => 'ProjectDocument was successfully destroyed.')
	end

  def show
    @project_document = ProjectDocument.find(params[:id])
    redirect_to project_path(@project_document.project)
  end
  
  def edit
    @project_document = ProjectDocument.find(params[:id])
    redirect_to project_path(@project_document.project)
  end
  
  def new
    @project = Project.find(params[:project_id])
    redirect_to project_path(@project)
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
    @project_document = ProjectDocument.find(params[:id])
    
    if @project_document.update_attributes(params[:project_document])
      redirect_to(project_path(@project_document.project), :notice => 'ProjectDocument was successfully updated.')
    else
      redirect_to(project_path(@project_document.project), :alert => 'ProjectDocument could not be updated.')
    end
  end

end
