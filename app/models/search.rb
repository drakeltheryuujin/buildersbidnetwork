class Search
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :q, :section, :location, :distance, :type_ids
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
    @q = "" unless @q
  end

  def results
    case @section
	    when :contractors.to_s
	      relation = @q.blank? ? ContractorProfile.scoped : ContractorProfile.search(@q)
	    when :developers.to_s
	      relation = @q.blank? ? DeveloperProfile.scoped : DeveloperProfile.search(@q)
	    else
	      relation = @q.blank? ? Project.scoped : Project.search(@q)
        unless @type_ids.blank?
          relation = relation.where(:project_type_id => @type_ids)
        end
	  end
    
    if ! @location.blank?
      relation = relation.near(@location, @distance)
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
