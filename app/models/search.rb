class Search
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :q, :section, :location, :distance, :type_ids, :order
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

    if @order == :distance.to_s && @location.blank?
      # FIXME handle this case better
      @order = :name.to_s
    end
  end

  def results
    case @section
	    when :contractors.to_s
	      relation = @q.blank? ? ContractorProfile.scoped : ContractorProfile.search(@q)
	    when :developers.to_s
	      relation = @q.blank? ? DeveloperProfile.scoped : DeveloperProfile.search(@q)
	    else
	      relation = @q.blank? ? Project.scoped : Project.search(@q)
        relation = relation.where("bidding_end > :now", :now => Time.now)
        relation = relation.where(:private => false)
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
        relation = relation.order(:id) # TODO project values
      when :time_left.to_s
        relation = relation.order(:bidding_end)
      else
        relation = relation.order(:name)
    end

    relation
  end

  def section_matches?(section) 
    @section.to_s == section.to_s
  end

  def persisted?
    false
  end
end
