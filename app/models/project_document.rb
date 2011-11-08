class ProjectDocument < ActiveRecord::Base
  belongs_to :project
  
  attr_accessible :asset, :asset_file_name, :asset_content_type, :asset_file_size, :asset_updated_at, :description
  has_attached_file :asset, {
	  :styles => { :thumb  => "100x100", :large => "600x400" }
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
    
  before_post_process :is_image?
  def is_image?
    !(asset_content_type =~ /^image/).nil?
  end
end
