class BidDocument < ActiveRecord::Base
  belongs_to :bid
  
  attr_accessible :asset, :asset_file_name, :asset_content_type, :asset_file_size, :asset_updated_at, :description
  has_attached_file :asset, {
	  :styles => { :thumb  => "100x100", :large => "600x400", :square_thumb => "94x94#" }
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
    
  scope :image, where(["asset_content_type LIKE ?", "image%"])
  scope :doc, where(["asset_content_type NOT LIKE ?", "image%"])

  before_post_process :is_image?
  def is_image?
    !(asset_content_type =~ /^image/).nil?
  end
end
# == Schema Information
#
# Table name: bid_documents
#
#  id                 :integer         not null, primary key
#  description        :string(255)
#  asset_file_name    :string(255)
#  asset_content_type :string(255)
#  asset_file_size    :integer
#  asset_updated_at   :datetime
#  bid_id             :integer
#  created_at         :datetime
#  updated_at         :datetime
#

