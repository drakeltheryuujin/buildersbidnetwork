class AddStateToBid < ActiveRecord::Migration
  def change
    add_column :bids, :state, :string, :default => 'draft'
    Bid.all.each do |bid|
      bid.state = :draft
      bid.save! :validate => false
    end
  end
end
