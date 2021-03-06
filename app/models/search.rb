class Search
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :q, :section, :location, :distance, :type_ids, :order, :page
#attr_reader :relation

#def initialize(relation) 
#    @relation = relation
#  end
  def initialize(attributes = {})
    if attributes 
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end
    @section = :projects.to_s unless @section
    @type_ids = [] unless @type_ids
    @order = (@section == :projects.to_s ? :time_left.to_s : :name.to_s) unless @order
    @q = "" unless @q
    
    @page = 1 unless @page
    
    if @order == :distance.to_s && @location.blank?
      # FIXME handle this case better
      @order = :name.to_s
    end
  end

  def results
    case @section
	    when :contractors.to_s
	      relation = @q.blank? ? ContractorProfile.distinct_visible : ContractorProfile.distinct_visible.search(@q)
        unless @type_ids.blank?
          relation = relation.joins(:project_types).where(:profiles_project_types => {:project_type_id => @type_ids})
        end
	    when :developers.to_s
	      relation = @q.blank? ? DeveloperProfile.distinct_visible : DeveloperProfile.distinct_visible.search(@q)
        unless @type_ids.blank? # FIXME DRY-out
          relation = relation.joins(:project_types).where(:profiles_project_types => {:project_type_id => @type_ids})
        end
	    else
	      relation = @q.blank? ? Project.not_deleted : Project.not_deleted.search(@q)
        relation = relation.where("bidding_end > :now", :now => Time.now)
        relation = relation.where(:private => false, :state => :published.to_s)
        unless @type_ids.blank?
          relation = relation.where(:project_type_id => @type_ids)
        end
	  end
    
    if ! @location.blank?
      relation = relation.near(@location, @distance)
    end
    
    
    case @order
      when :distance.to_s
        relation = relation.order(:distance)
      when :value.to_s
        relation = relation.order(:credit_value) 
      when :time_left.to_s
        relation = relation.order(:bidding_end)
      else
        relation = relation.order(:name)
    end

    relation.page(@page)
  end

  def section_matches?(section) 
    @section.to_s == section.to_s
  end

  def persisted?
    false
  end
end
